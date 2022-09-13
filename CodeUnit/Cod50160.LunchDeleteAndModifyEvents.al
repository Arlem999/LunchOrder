codeunit 50160 "Lunch Delete And Modify Events"
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Table, Database::"Lunch Menu", 'OnBeforeModifyEvent', '', true, true)]

    local procedure OnBeforeModifyEvent(var Rec: Record "Lunch Menu")
    var
        LunchOrderEntry: Record "Lunch Order Entry";
        ErrorTxt: Label 'Sorry, but this item has already been added to the order';
    begin
        IF Rec.ISTEMPORARY THEN
            EXIT;
        LunchOrderEntry.SETRANGE("Vendor No.", Rec."Vendor No.");
        LunchOrderEntry.SETRANGE("Order Date", Today);
        LunchOrderEntry.SETRANGE("Menu Item Entry No.", Rec."Menu Item Entry No.");
        IF NOT LunchOrderEntry.ISEMPTY THEN
            ERROR(ErrorTxt);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Lunch Menu", 'OnBeforeDeleteEvent', '', true, true)]

    local procedure OnBeforeDeleteEvent(var Rec: Record "Lunch Menu")
    var
        LunchOrderEntry: Record "Lunch Order Entry";
        ErrorTxt: Label 'Sorry, but this item has already been added to the order';
    begin
        IF Rec.ISTEMPORARY THEN
            EXIT;
        LunchOrderEntry.SETRANGE("Vendor No.", Rec."Vendor No.");
        LunchOrderEntry.SETRANGE("Order Date", Today);
        LunchOrderEntry.SETRANGE("Menu Item Entry No.", Rec."Menu Item Entry No.");
        IF NOT LunchOrderEntry.ISEMPTY THEN
            ERROR(ErrorTxt);

    end;
}
