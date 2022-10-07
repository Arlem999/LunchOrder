codeunit 50199 "SMA Import Exchange Rates NO"
{
    trigger OnRun()
    begin
    end;

    var
        XMLUnexpectedErr: Label 'Unexpected XML structure.';
        UnexpectedAttrErr: Label 'Unexpected %1 attribute format.', Comment = '%1= attribute name';
        UnexpectedNoteErr: Label 'Unexpected %1 node value.', Comment = '%1 = node name';
        ImportExchangeRatesURL: Label 'https://data.norges-bank.no/api/data/EXR/B.%1.NOK.SP?format=sdmx-generic-2.1&startPeriod=%2&endPeriod=%2&locale=en';

    procedure GetOfficialCurrencyRates(CompanyName: Text[30]; var CurrencyExchangeRateTmp: Record "Currency Exchange Rate" temporary; var CurrencyTmp: Record Currency temporary; Date: Date; ImportAllCurrencies: Boolean; var IsHandled: Boolean)
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        DateLoaded: Date;
        ExchRateAmount: Decimal;
        RelationalExchRateAmount: Decimal;
    begin
        IsHandled := true;

        LoadCurrencyXMLforNO(Date, TempXMLBuffer, DateLoaded, CompanyName);
        if Date <> DateLoaded then
            exit;
        if CurrencyTmp.FindSet() then
            repeat
                if GetExchRateParameters(CurrencyTmp.Code, ExchRateAmount, RelationalExchRateAmount, TempXMLBuffer) then begin
                    CurrencyExchangeRateTmp.Init();
                    CurrencyExchangeRateTmp."Currency Code" := CurrencyTmp.Code;
                    CurrencyExchangeRateTmp."Starting Date" := Date;
                    CurrencyExchangeRateTmp."Exchange Rate Amount" := ExchRateAmount;
                    CurrencyExchangeRateTmp."Adjustment Exch. Rate Amount" := ExchRateAmount;
                    CurrencyExchangeRateTmp."Relational Exch. Rate Amount" := RelationalExchRateAmount;
                    CurrencyExchangeRateTmp."Relational Adjmt Exch Rate Amt" := RelationalExchRateAmount;
                    CurrencyExchangeRateTmp.Insert();
                end;
            until CurrencyTmp.Next() = 0;
    end;

    local procedure LoadCurrencyXMLforNO(DateReq: Date; var TempXMLBuffer: Record "XML Buffer" temporary; var DateLoaded: Date; CompanyName: Text[30])
    var
        TempBlob: Codeunit "Temp Blob";
        Client: HttpClient;
        Response: HttpResponseMessage;
        Inst: InStream;
        DateReqText: Text[10];
    begin
        DateReqText := Format(DateReq, 0, '<Year4>-<Month,2>-<Day,2>');
        Client.Get(StrSubstNo(ImportExchangeRatesURL, GetCurrencyFilter(CompanyName), DateReqText), Response);
        TempBlob.CreateInStream(Inst);
        if Response.IsSuccessStatusCode then begin
            Response.Content().ReadAs(Inst);
            TempXMLBuffer.LoadFromStream(Inst);
            TempXMLBuffer.SetRange(Name, 'GenericData');
            TempXMLBuffer.SetRange(Type, TempXMLBuffer.Type::Element);
            if not TempXMLBuffer.FindFirst() then
                Error(XMLUnexpectedErr);
            TempXMLBuffer.SetRange(Name, 'ReportingBegin');
            TempXMLBuffer.SetRange(Type, TempXMLBuffer.Type::Element);
            if TempXMLBuffer.FindFirst then
                if not EvaluateDate(DateLoaded, Format(TempXMLBuffer.Value)) then
                    Error(UnexpectedAttrErr, 'ReportingBegin');
        end;
    end;

    local procedure GetExchRateParameters(FindCurrencyCode: Code[10]; var ExchRateAmount: Decimal; var RelationalExchRateAmount: Decimal; var TempXMLBuffer: Record "XML Buffer" temporary): Boolean
    var
        XMLBuffer2: Record "XML Buffer" temporary;
        ParentEntryNo: Integer;
        ExchRateAmountTemp: Decimal;
        TagFinded: Boolean;
        ValAttr: Text[250];
        i: Integer;
    begin
        TempXMLBuffer.Reset();
        XMLBuffer2.Copy(TempXMLBuffer, true);
        TempXMLBuffer.SetRange(Path, '/message:GenericData/message:DataSet/generic:Series/generic:SeriesKey/generic:Value/@value'); //@ - attribute
        TempXMLBuffer.SetRange(Value, FindCurrencyCode);

        if TempXMLBuffer.FindFirst() then begin
            XMLBuffer2.Get(TempXMLBuffer."Parent Entry No.");
            XMLBuffer2.GetParent();
            ParentEntryNo := XMLBuffer2."Parent Entry No.";

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Name, 'Obs');
            XMLBuffer2.FindFirst();
            ParentEntryNo := XMLBuffer2."Entry No.";

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Name, 'ObsValue');
            XMLBuffer2.FindFirst();
            ParentEntryNo := XMLBuffer2."Entry No.";

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Path, '/message:GenericData/message:DataSet/generic:Series/generic:Obs/generic:ObsValue/@value'); //@ - attribute
            XMLBuffer2.FindFirst();

            if not Evaluate(RelationalExchRateAmount, XMLBuffer2.Value, 9) then
                Error(UnexpectedNoteErr, 'generic:ObsValue');

            XMLBuffer2.Get(TempXMLBuffer."Parent Entry No.");
            XMLBuffer2.GetParent();
            ParentEntryNo := XMLBuffer2."Parent Entry No.";

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Name, 'Attributes');
            XMLBuffer2.FindFirst();
            ParentEntryNo := XMLBuffer2."Entry No.";
            TagFinded := false;

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Name, 'Value');
            XMLBuffer2.FindSet();
            repeat
                ValAttr := XMLBuffer2.GetAttributeValue('id');
                if ValAttr = 'UNIT_MULT' then begin
                    TagFinded := true;
                    ParentEntryNo := XMLBuffer2."Entry No.";
                end;
            until (XMLBuffer2.Next() = 0) or TagFinded;

            XMLBuffer2.Reset();
            XMLBuffer2.SetRange("Parent Entry No.", ParentEntryNo);
            XMLBuffer2.SetRange(Path, '/message:GenericData/message:DataSet/generic:Series/generic:Attributes/generic:Value/@value'); //@ - attribute
            XMLBuffer2.FindFirst();

            if not Evaluate(ExchRateAmountTemp, XMLBuffer2.Value, 9) then
                Error(UnexpectedNoteErr, 'generic:Value/@value');

            i := 0;
            ExchRateAmount := 1;

            while i < ExchRateAmountTemp do begin
                ExchRateAmount *= 10;
                i += 1;
            end;
            exit(true);
        end;
    end;

    local procedure EvaluateDate(var DateLoaded: Date; Str: Text[30]): Boolean
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        if not Evaluate(Day, CopyStr(Str, 9, 2)) then
            exit(false);

        if not Evaluate(Month, CopyStr(Str, 6, 2)) then
            exit(false);

        if not Evaluate(Year, CopyStr(Str, 1, 4)) then
            exit(false);

        DateLoaded := DMY2Date(Day, Month, Year);

        exit(true);
    end;

    local procedure GetCurrencyFilter(CompanyName: Text[30]): Text[250]
    var
        CurrencyLocal: Record Currency;
        CurrenciesText: Text[250];
    begin
        CurrencyLocal.Reset();
        CurrencyLocal.ChangeCompany(CompanyName);
        if CurrencyLocal.FindSet() then
            repeat
                if CurrenciesText = '' then
                    CurrenciesText := CurrencyLocal.Code else
                    CurrenciesText += '+' + CurrencyLocal.Code;
            until CurrencyLocal.Next() = 0;
    end;
}

