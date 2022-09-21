codeunit 50104 OnAfterUpdateSalesHeader
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateSalesHeader', '', true, true)]
    local procedure OnAfterUpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry"; var SalesInvoiceHeader: Record "Sales Invoice Header")

    begin
        CustLedgerEntry."Posting Description ARLEM" := SalesInvoiceHeader."Posting Description ARLEM";
        CustLedgerEntry.Modify();
    end;
}
