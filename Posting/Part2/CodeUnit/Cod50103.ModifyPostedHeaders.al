codeunit 50103 OnAfterInsertPostedHeaders
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertPostedHeaders', '', true, true)]
    local procedure OnAfterInsertPostedHeaders(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")

    begin
        PurchaseHeader.CalcFields("Number of lines");
        PurchInvHeader."Number of lines" := PurchaseHeader."Number of lines";
        PurchInvHeader.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertPostedHeaders', '', true, true)]
    local procedure OnAfterInsertReceiptHeader(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header")

    begin
        PurchaseHeader.CalcFields("Number of lines");
        PurchRcptHeader."Number of lines" := PurchaseHeader."Number of lines";
        PurchRcptHeader.Modify();
    end;
}
