codeunit 50102 ImportExcelFile
{
    var
        UploadMessage: Label 'Please Choose the Excel File: ';
        NoFileFoundMsg: Label 'File Not Found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: text;
        SheetName: Text;
        FldRef: FieldRef;
        ErrorAccountNo: Label 'The field Account No. of table Gen. Journal Line cannot be found in the related table (G/L Account).';
        ErrorMessage: Label '- This Field not pass validation';
        ErrorInsert: Label 'Sorry, we cant insert this Line';

    procedure ReadExelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
    begin
        UploadIntoStream(UploadMessage, '', '', FromFile, IStream);
        If FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    procedure ImportExcelData(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        ShowErrors: Codeunit "Show Errors";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        ExternalDocumentNo: Code[35];
        AccountNo: Code[35];
        PostingDate: Date;
        AmountLCY: Decimal;
        ShortcutDimension1Code: Code[20];
        RecRef: RecordRef;
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";
        GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";

        RecRef.Open(Database::"Gen. Journal Line");

        for RowNo := 2 to MaxRowNo do begin
            if GetValueAtCell(RowNo, 1) <> '' then begin
                LineNo := LineNo + 10000;
                GenJournal.Init();
                GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");

                FldRef := RecRef.Field(Rec.FieldNo("Line No."));
                if ValidateField(FldRef, LineNo) then
                    GenJournal.Validate("Line No.", LineNo)
                else
                    Error(ErrorInfo.Create('Format(Rec."Line No.") + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                Evaluate(ExternalDocumentNo, GetValueAtCell(RowNo, 1));
                Evaluate(AccountNo, GetValueAtCell(RowNo, 2));
                Evaluate(PostingDate, GetValueAtCell(RowNo, 3));
                Evaluate(AmountLCY, GetValueAtCell(RowNo, 4));
                Evaluate(ShortcutDimension1Code, '000' + (GetValueAtCell(RowNo, 5)) +
                 '.00' + GetValueAtCell(RowNo, 7) + '.0' + GetValueAtCell(RowNo, 9));

                FldRef := RecRef.Field(Rec.FieldNo("External Document No."));
                if ValidateField(FldRef, ExternalDocumentNo) then
                    GenJournal.Validate(Description, ExternalDocumentNo)
                else
                    Error(ErrorInfo.Create('Rec."External Document No." + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                // FldRef := RecRef.Field(Rec.FieldNo("Account No."));
                // if ValidateField(FldRef, AccountNo) then
                //     GenJournal.Validate("Account No.", AccountNo)
                // else
                //     Error(ErrorInfo.Create(ErrorAccountNo, true, Rec, Rec.FieldNo("Account No.")));

                FldRef := RecRef.Field(Rec.FieldNo("Posting Date"));
                if ValidateField(FldRef, PostingDate) then
                    GenJournal.Validate("Posting Date", PostingDate)
                else
                    Error(ErrorInfo.Create('Format(Rec."Posting Date") + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                FldRef := RecRef.Field(Rec.FieldNo("Amount (LCY)"));
                if ValidateField(FldRef, AmountLCY) then
                    GenJournal.Validate("Amount (LCY)", AmountLCY)
                else
                    Error(ErrorInfo.Create('Format(Rec."Amount (LCY)") + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                FldRef := RecRef.Field(Rec.FieldNo("Shortcut Dimension 1 Code"));
                if ValidateField(FldRef, ShortcutDimension1Code) then
                    GenJournal.Validate("Shortcut Dimension 1 Code", ShortcutDimension1Code)
                else
                    Error(ErrorInfo.Create('Rec."Shortcut Dimension 1 Code" + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                FldRef := RecRef.Field(Rec.FieldNo(Description));
                if ValidateField(FldRef, GetValueAtCell(RowNo, 11)) then
                    GenJournal.Validate(Description, GetValueAtCell(RowNo, 11))
                else
                    Error(ErrorInfo.Create('Rec.Description + ErrorMessage', true, Rec, Rec.FieldNo("Account No.")));

                If not GenJournal.Insert() then
                    Error(ErrorInfo.Create('ErrorInsert', true, Rec, Rec.FieldNo("Account No.")));
            end;

            ShowErrors.ShowErrors(GetCollectedErrors(), Rec.RecordId);
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    [TryFunction]
    local procedure ValidateField(var FldRef: FieldRef; NewValue: Variant)
    begin
        FldRef.Validate(NewValue);
    end;
}
