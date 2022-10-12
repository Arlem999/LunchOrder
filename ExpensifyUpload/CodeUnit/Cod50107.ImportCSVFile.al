codeunit 50107 ImportCSVFile
{
    var
        CSVBufer: Record "CSV Buffer" temporary;
        ResponseTxt: Text;
        Template: Label '&template=<#-- Header -->Timestamp,Merchant,Amount,MCC,Category,Tag,Description,Reimbursable,"Original Currency","Original Amount",Receipt,Attendees<#list reports as report><#list report.transactionList as expense>${expense. created},<#t>${expense.merchant},<#t>${(expense.amount/100)?string("0.00")},<#t>${expense.mcc},<#t>${expense.category},<#t>${expense.tag},<#t>${expense.description},<#t>${expense. reimbursable?string("yes", "no")},<#t>${expense. currency},<#t>${(expense.amount/100)?string("0.00")},<#t>${expense. receipt.url},<#t>${expense.attendees.displayName}<#lt></#list></#list>';
        RequestJobDescription: Label 'requestJobDescription={"test": "true","type": "file","credentials":{"partnerUserID": "%1", "partnerUserSecret": "%2" },"onReceive":{"immediateResponse":["returnRandomFileName"] }, "inputSettings":{ "type":"combinedReportData", "filters":{ "startDate":"2022-10-1", } }, "outputSettings":{"fileExtension":"csv" }, "onFinish":[{"actionName":"markAsExported","label":"Partner name"}]}';
        DownloadFile: Label 'requestJobDescription={"type":"download","credentials":{"partnerUserID":"%1", "partnerUserSecret":"%2"},"fileName":"%3","fileSystem":"integrationServer"}';
        UploadMessage: Label 'Please Choose the CSV File: ';
        ErrorSetup: Label 'You need to add SMA Setup first';
        ErrorMessageURL: Label 'Sorry, connection to this URL is failed';
        BadStatusCode: Label 'Web Service call failed (status code %1)';
        URL: Label 'https://integrations.expensify.com/Integration-Server/ExpensifyIntegrations';

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

    procedure ImportCSVDataFromFile(Rec: Record "Gen. Journal Line")
    var
        GenJournal: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        RowNo: Integer;
        LineNo: Integer;
        Amount: Decimal;
        AmountLCY: Decimal;
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
            if GetValue(RowNo, 3) <> '' then begin
                Evaluate(AmountLCY, GetValue(RowNo, 3));
                GenJournal.Validate("Amount (LCY)", AmountLCY);
            end;
            GenJournal.Validate("Reimbursable", TextToBoolean(GetValue(RowNo, 8)));
            if GetValue(RowNo, 10) <> '' then begin
                Evaluate(Amount, GetValue(RowNo, 10));
                GenJournal.Validate(Amount, Amount);
            end;
            GenJournal.Validate("Receipt", GetValue(RowNo, 11));
            GenJournal.Validate("Account Type", Rec."Account Type"::"G/L Account");
            GenJournal.Validate("Bal. Account Type", Rec."Bal. Account Type"::Vendor);
            GenJournal."Bal. Account No." := Vendor.GetVendorNo(DelChr(GetValue(RowNo, 12), '=', ','));
            DocumentNo := GetValue(RowNo, 1).Split(' ').Get(1);
            GenJournal."Document No." := 'EXP' + DelChr(DocumentNo, '=', '-');
            GenJournal."Currency Code" := GetValue(RowNo, 9);
            GenJournal.Validate(Description, GetValue(RowNo, 7));
            GenJournal.Insert();
        end;
    end;

    procedure LoadCSVData()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        SMASetup: Record "SMA Expensify Integr. Setup";
        InStream: InStream;
        Content: HttpContent;
        Headers: HttpHeaders;
    begin
        if not SMASetup.Get() then
            Error(ErrorSetup);
        Request.Method := 'POST';
        Request.SetRequestUri(URL);
        Content.WriteFrom(StrSubstNo(RequestJobDescription, SMASetup.PartnerUserID, SMASetup.PartnerUserSecret)
         + Template);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.Content(Content);

        If Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode then
                Response.Content.ReadAs(ResponseTxt)
            else
                Error(BadStatusCode, Response.HttpStatusCode);
        end else
            Error(ErrorMessageURL);

        DownloadCSV();
    end;

    local procedure DownloadCSV()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        SMASetup: Record "SMA Expensify Integr. Setup";
        CSVStream: InStream;
        Content: HttpContent;
        Headers: HttpHeaders;
    begin
        if not SMASetup.Get() then
            Error(ErrorSetup);
        Request.Method := 'POST';
        Request.SetRequestUri(URL);
        Content.WriteFrom(StrSubstNo(DownloadFile, SMASetup.PartnerUserID, SMASetup.PartnerUserSecret, ResponseTxt));
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.Content(Content);
        If Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode then begin
                Response.Content.ReadAs(CSVStream);
                CSVBufer.LoadDataFromStream(CSVStream, ',');
                Message(Format(CSVBufer.GetNumberOfLines()));
            end else
                Error(BadStatusCode, Response.HttpStatusCode);
        end else
            Error(ErrorMessageURL);
    end;

    local procedure MyProcedure()
    var
        myInt: Integer;
    begin

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
