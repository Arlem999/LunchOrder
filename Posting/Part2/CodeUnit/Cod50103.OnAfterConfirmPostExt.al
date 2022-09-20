codeunit 50103 OnAfterConfirmPostExt
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin

    end;
}
