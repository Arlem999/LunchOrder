codeunit 50107 ImportCSVFile
{
    var
        CSVBufer: Record "CSV Buffer" temporary;
        UploadMessage: Label 'Please Choose the CSV File: ';
        XMLUnexpectedErr: Label 'Unexpected CSV structure.';
        ImportExchangeRatesURL: Label 'https://integrations.expensify.com/Integration-Server/ExpensifyIntegrations';

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
    end;

    procedure ImportCSVData(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        RowNo: Integer;
        LineNo: Integer;
        Amount: Decimal;
        DocumentNo: Text;
    begin
        GenJournal.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";

        for RowNo := 2 to CSVBufer.GetNumberOfLines() do begin
            LineNo := LineNo + 10000;
            GenJournal.Init();
            GenJournal.Validate("Journal Template Name", Rec."Journal Template Name");
            GenJournal.Validate("Journal Batch Name", Rec."Journal Batch Name");
            GenJournal.Validate("Line No.", LineNo);
            Evaluate(GenJournal."Posting Date", GetValue(RowNo, 1).Split(' ').Get(1));
            GenJournal.Validate("External Document No.", GetValue(RowNo, 2));
            Evaluate(Amount, GetValue(RowNo, 3));
            GenJournal.Validate("Amount (LCY)", Amount);
            GenJournal.Validate("Reimbursable", TextToBoolean(GetValue(RowNo, 8)));
            GenJournal."Currency Code" := GetValue(RowNo, 9);
            Evaluate(Amount, GetValue(RowNo, 10));
            GenJournal.Amount := Amount;
            GenJournal.Validate("Receipt", GetValue(RowNo, 11));
            GenJournal.Validate("Account Type", Rec."Account Type"::"G/L Account");
            GenJournal.Validate("Bal. Account Type", Rec."Bal. Account Type"::Vendor);
            Vendor.SetRange(Name, GetValue(RowNo, 12));
            If Vendor.FindLast() then
                GenJournal."Bal. Account No." := Vendor."No.";
            DocumentNo := GetValue(RowNo, 1).Split(' ').Get(1);
            GenJournal."Document No." := 'EXP' + DelChr(DocumentNo, '=', '-');
            GenJournal.Validate(Description, GetValue(RowNo, 7));
            GenJournal.Insert();
            CSVBufer.Reset();
            CSVBufer.DeleteAll();
        end;
    end;

    procedure LoadCSVData(DateReq: Date; var TempXMLBuffer: Record "XML Buffer" temporary; var DateLoaded: Date; CompanyName: Text[30])
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Inst: InStream;
        DateReqText: Text[10];
    begin
        // DateReqText := Format(DateReq, 0, '<Year4>-<Month,2>-<Day,2>');
        // Client.Get(StrSubstNo(ImportExchangeRatesURL, GetCurrencyFilter(CompanyName), DateReqText), Response);
        // TempBlob.CreateInStream(Inst);
        // if Response.IsSuccessStatusCode then begin
        //     Response.Content().ReadAs(Inst);
        //     TempXMLBuffer.LoadFromStream(Inst);
        //     TempXMLBuffer.SetRange(Name, 'GenericData');
        //     TempXMLBuffer.SetRange(Type, TempXMLBuffer.Type::Element);
        //     if not TempXMLBuffer.FindFirst() then
        //         Error(XMLUnexpectedErr);
        //     TempXMLBuffer.SetRange(Name, 'ReportingBegin');
        //     TempXMLBuffer.SetRange(Type, TempXMLBuffer.Type::Element);
        //     if TempXMLBuffer.FindFirst then
        //         if not EvaluateDate(DateLoaded, Format(TempXMLBuffer.Value)) then
        //             Error(UnexpectedAttrErr, 'ReportingBegin');
        // end;
    end;

    local procedure GetValue(RowNo: Integer; ColNo: Integer): Text
    begin
        if CSVBufer.Get(RowNo, ColNo) then
            exit(CSVBufer.Value.TrimEnd('"').TrimStart('"'))
        else
            exit('')
    end;

    local procedure TextToBoolean(YesOrNo: text): Boolean
    begin
        if YesOrNo <> 'yes' then
            exit(false)
        else
            exit(true)
    end;
}
