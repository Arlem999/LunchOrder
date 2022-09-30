codeunit 50102 ImportExcelFile
{
    var
        UploadMessage: Label 'Please Choose the Excel File: ';
        NoFileFoundMsg: Label 'File Not Found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: text;
        SheetName: Text;

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

    procedure ImportExcelData(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        ExternalDocumentNo: Code[35];
        AccountNo: Code[35];
        PostingDate: Date;
        AmountLCY: Decimal;
        ShortcutDimension1Code: Code[20];
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";
        GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";

        for RowNo := 2 to MaxRowNo do begin
            if GetValueAtCell(RowNo, 1) <> '' then begin
                LineNo := LineNo + 10000;
                GenJournal.Init();
                GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
                GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
                GenJournal.Validate("Line No.", LineNo);
                Evaluate(ExternalDocumentNo, GetValueAtCell(RowNo, 1));
                Evaluate(AccountNo, GetValueAtCell(RowNo, 2));
                Evaluate(PostingDate, GetValueAtCell(RowNo, 3));
                Evaluate(AmountLCY, GetValueAtCell(RowNo, 4));
                Evaluate(ShortcutDimension1Code, '000' + (GetValueAtCell(RowNo, 5)) +
                 '.00' + GetValueAtCell(RowNo, 7) + '.0' + GetValueAtCell(RowNo, 9));
                GenJournal.Validate("External Document No.", ExternalDocumentNo);
                GenJournal.Validate("Account No.", AccountNo);
                GenJournal.Validate("Posting Date", PostingDate);
                GenJournal.Validate("Amount (LCY)", AmountLCY);
                GenJournal.Validate("Shortcut Dimension 1 Code", ShortcutDimension1Code);
                GenJournal.Validate(Description, GetValueAtCell(RowNo, 11));
                GenJournal.Insert();
            end;
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
}
