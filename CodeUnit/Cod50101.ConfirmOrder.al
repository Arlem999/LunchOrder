codeunit 50101 ConfirmOrder
{
    procedure SaveOrder(var Rec: Record "Lunch Menu")
    var
        ConfirmOrder: Boolean;
        OrderExist: Boolean;
        LunchOrder: Record "Lunch Order Entry";
        ConfirmOrderTxt: Label 'Confirm the order ?';
    begin
        Rec.SetFilter("Order Quantity", '>0');
        if not Rec.IsEmpty then
            IF CONFIRM(ConfirmOrderTxt, TRUE) THEN
                ConfirmOrder := true;

        IF ConfirmOrder THEN
            IF Rec.FINDSET THEN BEGIN

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
                            LunchOrder."Entry No." := 0;
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

        Rec.DELETEALL(true);
    end;
}
