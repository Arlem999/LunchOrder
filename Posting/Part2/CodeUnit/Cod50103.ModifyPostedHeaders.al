codeunit 50103 OnAfterInsertPostedHeaders
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertPostedHeaders', '', true, true)]
    local procedure OnAfterInsertPostedHeaders(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var PurchSetup: Record "Purchases & Payables Setup")

    begin
        PurchaseHeader.CalcFields("Number of lines");
        if PurchaseHeader."Number of lines" <> 0 then begin
            if PurchInvHeader."No." <> '' then begin
                PurchInvHeader."Number of lines" := PurchaseHeader."Number of lines";
                PurchInvHeader.Modify();
            end;
            if PurchRcptHeader."No." <> '' then begin
                PurchRcptHeader."Number of lines" := PurchaseHeader."Number of lines";
                PurchaseHeader.Modify();
            end;
        end;
    end;
}
