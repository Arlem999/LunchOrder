codeunit 50105 "Import Txt File"
{
    var
        UploadMessage: Label 'Please Choose the Txt File: ';
        NoFileFoundMsg: Label 'File Not Found!';
        TxtImportSucess: Label 'Txt is successfully imported.';
        StackOfTxt: List of [Text];
        StackTxt: Text;
        LineTxt: Text;
        FldRef: FieldRef;
        ErrorAccountNo: Label 'The field Account No. of table Gen. Journal Line cannot be found in the related table (G/L Account).';
        ErrorMessage: Label '- This Field not pass validation';
        ErrorInsert: Label 'Sorry, we cant insert this Line';

    procedure ReadTxtFile()
    var
        IStream: InStream;
        FromFile: Text;
        NumberOfBytesRead: Integer;
    begin
        if UploadIntoStream(UploadMessage, '', '', FromFile, IStream) then
            while not (IStream.EOS) do begin
                IStream.ReadText(StackTxt);
                if StrLen(StackTxt) <> 0 then begin
                    if (StackTxt.StartsWith('"')) and (StackTxt[2] in ['0' .. '9']) then
                        StackOfTxt.Add(StackTxt);
                end;
            end else
            Message(NoFileFoundMsg);
    end;

    procedure ImportTxtData(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        ShowErrors: Codeunit "Show Errors";
        PostDateTxt: Text;
        PostDate: Date;
        AmountLCY: Decimal;
        Amount: Decimal;
        LineNo: Integer;
        DbAcCl: Text; // GenJournal."Account Type"
        CrAcCl: Text;
        CrAcNo: Text; // GenJournal."Account No."
        DbAcNo: Text;
        RecRef: RecordRef;
    begin
        GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";

        RecRef.Open(Database::"Gen. Journal Line");

        foreach LineTxt in StackOfTxt do begin
            LineNo := LineNo + 10000;
            GenJournal.Init();
            GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
            GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
            // GenJournal.Validate("Line No.", LineNo);
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));

            //  GenJournal.Validate("Document No.", ParsingString());
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));
            PostDateTxt := ParsingString();
            Evaluate(PostDate, COPYSTR(PostDateTxt, 1, 4) + '-' + COPYSTR(PostDateTxt, 5, 2) + '-' + COPYSTR(PostDateTxt, 7, 2));
            // GenJournal.Validate("Posting Date", PostDate);
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));
            SkipLine(1);
            // GenJournal.Validate(Description, ParsingString());
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));
            DbAcCl := ParsingString();
            DbAcNo := ParsingString();
            SkipLine(1);
            CrAcCl := ParsingString();
            CrAcNo := ParsingString();
            SkipLine(1);

            if DbAcCl = '0' then begin
                if CrAcCl = '1' then begin
                    GenJournal.Validate("Account Type", GenJournal."Account Type"::Customer);
                    GenJournal.Validate("Account No.", Format(CrAcNo));
                end else
                    if CrAcCl = '2' then begin
                        GenJournal.Validate("Account Type", GenJournal."Account Type"::Vendor);
                        GenJournal.Validate("Account No.", Format(CrAcNo));
                    end else
                        if CrAcCl = '3' then begin
                            GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
                            GenJournal.Validate("Account No.", Format(CrAcNo));
                        end
            end else
                if DbAcCl = '1' then begin
                    GenJournal.Validate("Account Type", GenJournal."Account Type"::Customer);
                    GenJournal.Validate("Account No.", Format(DbAcNo));
                end else
                    if DbAcCl = '2' then begin
                        GenJournal.Validate("Account Type", GenJournal."Account Type"::Vendor);
                        GenJournal.Validate("Account No.", Format(DbAcNo));
                    end else
                        if DbAcCl = '3' then begin
                            GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
                            GenJournal.Validate("Account No.", Format(DbAcNo));
                        end;

            // GenJournal.Validate("Currency Code", Format(ParsingString()));
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));
            SkipLine(1);
            Evaluate(Amount, Format(ParsingString()));
            // GenJournal.Validate(Amount, Amount);
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));
            Evaluate(AmountLCY, ParsingString());
            if (DbAcCl = '0') then
                GenJournal.Validate("Amount (LCY)", (-1) * AmountLCY)
            else
                GenJournal.Validate("Amount (LCY)", AmountLCY);

            SkipLine(3);
            // GenJournal.Validate("External Document No.", ParsingString);
            FldRef := RecRef.Field(Rec.FieldNo("Line No."));
            if ValidateField(FldRef, LineNo) then
                GenJournal.Validate("Line No.", LineNo)
            else
                Error(ErrorInfo.Create(Format(Rec."Line No.") + ErrorMessage, true, Rec, Rec.FieldNo("Account No.")));

            If not GenJournal.Insert() then
                Error(ErrorInfo.Create(ErrorInsert, true, Rec, Rec.FieldNo("Account No.")));
        end;
        Message(TxtImportSucess);
    end;

    local procedure ParsingString(): Text
    var
        Start, Ends : Integer;
        ReturnLine: Text;
    begin
        Start := LineTxt.IndexOf('"');
        LineTxt[Start] := ' ';
        Ends := LineTxt.IndexOf('"');
        LineTxt[Ends] := ' ';
        ReturnLine := LineTxt.Substring(Start, Ends - Start);
        LineTxt := LineTxt.Replace(LineTxt.Substring(Start, Ends - Start), ' ');
        exit(ReturnLine.Trim());
    end;

    local procedure SkipLine(QuantityOfLine: Integer)
    var
        Cycle: Integer;
    begin
        For Cycle := 1 TO QuantityOfLine do
            ParsingString();
    end;

    [TryFunction]
    local procedure ValidateField(var FldRef: FieldRef; NewValue: Variant)
    begin
        FldRef.Validate(NewValue);
    end;
}
