codeunit 50105 "Import Txt File"
{
    var
        UploadMessage: Label 'Please Choose the Txt File: ';
        NoFileFoundMsg: Label 'File Not Found!';
        TxtImportSucess: Label 'Txt is successfully imported.';
        StackOfTxt: List of [Text];
        StackTxt: Text;
        LineTxt: Text;

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

    procedure ImportTxtData()
    var
        GenJournal: Record "Gen. Journal Line";
        PostDate: Text;
        AmountLCY: Decimal;
        LineNo: Integer;
        DbAcCl: Text; // GenJournal."Account Type"
        CrAcCl: Text;
        CrAcNo: Text; // GenJournal."Account No."
        DbAcNo: Text;
    begin
        GenJournal.SetRange("Journal Template Name", 'GENERAL');
        GenJournal.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";

        foreach LineTxt in StackOfTxt do begin
            LineNo := LineNo + 10000;
            GenJournal.Init();
            GenJournal."Journal Template Name" := 'GENERAL';
            GenJournal."Journal Batch Name" := 'DEFAULT';
            GenJournal."Line No." := LineNo;
            GenJournal."Document No." := ParsingString();
            PostDate := ParsingString();
            Evaluate(GenJournal."Posting Date", COPYSTR(PostDate, 1, 4) + '-' + COPYSTR(PostDate, 5, 2) + '-' + COPYSTR(PostDate, 7, 2));
            SkipLine(1);
            GenJournal.Description := ParsingString();
            DbAcCl := ParsingString();
            DbAcNo := ParsingString();
            SkipLine(1);
            CrAcCl := ParsingString();
            CrAcNo := ParsingString();
            SkipLine(1);

            if DbAcCl = '0' then begin
                if CrAcCl = '1' then begin
                    GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                    GenJournal."Account No." := Format(CrAcNo);
                end else
                    if CrAcCl = '2' then begin
                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                        GenJournal."Account No." := Format(CrAcNo);
                    end else
                        if CrAcCl = '3' then begin
                            GenJournal."Account Type" := GenJournal."Account Type"::"G/L Account";
                            GenJournal."Account No." := Format(CrAcNo);
                        end
            end else
                if DbAcCl = '1' then begin
                    GenJournal."Account Type" := GenJournal."Account Type"::Customer;
                    GenJournal."Account No." := Format(DbAcNo);
                end else
                    if DbAcCl = '2' then begin
                        GenJournal."Account Type" := GenJournal."Account Type"::Vendor;
                        GenJournal."Account No." := Format(DbAcNo);
                    end else
                        if DbAcCl = '3' then begin
                            GenJournal."Account Type" := GenJournal."Account Type"::"G/L Account";
                            GenJournal."Account No." := Format(DbAcNo);
                        end;

            GenJournal."Currency Code" := Format(ParsingString());
            SkipLine(1);
            Evaluate(GenJournal.Amount, Format(ParsingString()));

            Evaluate(AmountLCY, ParsingString());
            if (DbAcCl = '0') then
                GenJournal."Amount (LCY)" := (-1) * AmountLCY
            else
                GenJournal."Amount (LCY)" := AmountLCY;

            SkipLine(3);
            GenJournal."External Document No." := ParsingString;

            GenJournal.Insert();
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
}
