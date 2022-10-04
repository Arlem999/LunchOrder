codeunit 50107 ImportCSVFile
{
    var
        CSVBufer: Record "CSV Buffer" temporary;
        UploadMessage: Label 'Please Choose the CSV File: ';

    procedure ReadCSVFile()
    var
        CSVStream: InStream;
        FileName: text;
        FileNotFound: Label 'File not found!';
    begin
        if UploadIntoStream(UploadMessage, '', '', FileName, CSVStream) then
            CSVBufer.LoadDataFromStream(CSVStream, ',')
        else
            Message(FileNotFound);
        Message(Format(CSVBufer.GetNumberOfLines()));
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    procedure ImportCSVData(Rec: Record "G/L Entry")
    var
        GenJournal: Record "Gen. Journal Line";
        RowNo: Integer;
        LineNo: Integer;
        AmountLCY: Decimal;
    begin
        for RowNo := 2 to CSVBufer.GetNumberOfLines() do begin
            LineNo := LineNo + 10000;
            GenJournal.Init();
            GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
            GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
            GenJournal.Validate("Line No.", LineNo);
            //  Evaluate(Rec."Posting Date", GetValue(RowNo, 1));
            GenJournal.Validate("External Document No.", GetValue(RowNo, 2));
            Evaluate(AmountLCY, GetValue(RowNo, 3));
            GenJournal.Validate("Amount (LCY)", AmountLCY);
            GenJournal.Validate(Description, GetValue(RowNo, 7));
            GenJournal.Validate("Reimbursable", GetValue(RowNo, 8));
            GenJournal.Validate("Currency Code", GetValue(RowNo, 9));
            GenJournal.Validate("Amount", GetValue(RowNo, 10));
            GenJournal.Validate("Receipt", GetValue(RowNo, 11));
            GenJournal.Validate("Account Type", Rec."Account Type"::"G/L Account");
            GenJournal.Validate("Bal. Account Type", Rec."Bal. Account Type"::Vendor);
            GenJournal.Validate("Name",);
            GenJournal.Validate("Document No.",);
            GenJournal.Insert()
        end;
    end;

    local procedure GetValue(RowNo: Integer; ColNo: Integer): Text
    begin
        if CSVBufer.Get(RowNo, ColNo) then
            exit(CSVBufer.Value.TrimEnd('"').TrimStart('"'))
        else
            exit('')
    end;
}
