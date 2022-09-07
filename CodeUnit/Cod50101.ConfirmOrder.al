codeunit 50101 ConfirmOrder
{
    procedure SaveOrder(var Rec: Record "Lunch Menu")
    var
        ConfirmOrder: Boolean;
        EntryNo: Integer;
        OrderExist: Boolean;
        LunchOrder: Record "Lunch Order Entry";
    begin
        Rec.SetFilter("Order Quantity", '>0');
        if not Rec.IsEmpty then
            IF CONFIRM('Confirm the order ?', TRUE) THEN
                ConfirmOrder := true;

        IF ConfirmOrder THEN
            IF Rec.FINDSET THEN BEGIN

                if Not LunchOrder.IsEmpty then begin
                    LunchOrder.FINDLAST;
                    EntryNo := LunchOrder."Entry No.";
                end;

                REPEAT
                    Rec.CalcFields("Previos Quantity");

                    IF Rec."Order Quantity" <> Rec."Previos Quantity" THEN BEGIN

                        LunchOrder.SETRANGE("Vendor No.", Rec."Vendor No.");
                        LunchOrder.SETRANGE("Order Date", Today);
                        LunchOrder.SETRANGE("Menu Item Entry No.", Rec."Menu Item Entry No.");
                        LunchOrder.SETRANGE("Resourse No.", USERID);

                        IF LunchOrder.FINDFIRST THEN BEGIN
                            LunchOrder.Quantity += Rec."Order Quantity";
                            LunchOrder.Amount += Rec."Order Amount";
                            LunchOrder.MODIFY(TRUE);
                        END ELSE BEGIN
                            EntryNo += 1;
                            LunchOrder."Entry No." := EntryNo;
                            LunchOrder."Menu Item Entry No." := Rec."Menu Item Entry No.";
                            LunchOrder."Vendor No." := Rec."Vendor No.";
                            LunchOrder."Menu Item No." := Rec."Item No.";
                            LunchOrder."Item Description" := Rec."Item Description";
                            LunchOrder.Quantity := Rec."Order Quantity";
                            LunchOrder.Price := Rec.Price;
                            LunchOrder."Dimension Set ID" := Rec."Dimension Set ID";
                            LunchOrder."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            LunchOrder."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            LunchOrder.Amount := Rec."Order Amount";
                            LunchOrder."Order Date" := Today;
                            LunchOrder."Resourse No." := USERID;
                            LunchOrder.INSERT(TRUE);
                        END;
                    END;
                UNTIL Rec.NEXT = 0;
            END;

        Rec.DELETEALL(TRUE);
    end;
}
