page 50155 "Lunch Order"

{
    Caption = 'Lunch Order';
    PageType = List;
    SourceTable = "Lunch Menu";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableTemporary = true;
    AutoSplitKey = true;
    Editable = true;

    layout
    {
        area(content)
        {
            group("Vendor selection: ")
            {
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    TableRelation = Vendor."No." where("Lunch Vendor" = const(true));


                    trigger OnValidate()
                    begin
                        Rec.DELETEALL;
                        LunchMenu.SETRANGE("Vendor No.", Rec."Vendor No.");
                        LunchMenu.FINDLAST;
                        LunchMenu.SETRANGE("Menu Date", LunchMenu."Menu Date");

                        IF LunchMenu.FINDSET THEN
                            REPEAT
                                Rec.INIT;
                                Rec := LunchMenu;
                                Rec.INSERT;
                            UNTIL LunchMenu.NEXT = 0;

                    end;
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            repeater(General)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Item Description";

                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;

                    trigger onValidate()

                    begin
                        Rec."Order Amount" := Rec."Order Quantity" * Rec.Price;
                    end;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Previos Quantity"; Rec."Previos Quantity")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Self Order"; Rec."Self Order")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Parent Menu Item No."; Rec."Parent Menu Item No.")
                {
                    ApplicationArea = All;
                    Editable = Rec.Active;
                    StyleExpr = BoltText;
                    Style = StrongAccent;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Edit Menu")
            {
                ApplicationArea = All;
                Caption = 'Edit Menu';
                Image = EditList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Lunch Menu Edit";
            }
        }
        area(Reporting)
        {
            action("Menu for Today")
            {
                ApplicationArea = all;
                Caption = 'Print Menu for Today';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = report "Menu For Today";
            }
        }
        area(Navigation)
        {
            action(Dimensions)
            {
                Image = Dimensions;
                ShortCutKey = "Shift+Ctrl+D";
                ApplicationArea = All;
                Caption = 'Dimensions';
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(50130), "No." = FIELD("Item No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BoltText := Rec."Line Type" = Rec."Line Type"::"Group Heading";
        If BoltText then
            Rec.Active := false;

    end;

    trigger OnClosePage()
    var
        ConfirmOrder: Boolean;
        EntryNo: Integer;
        OrderExist: Boolean;
    begin
        Rec.SetFilter("Order Quantity", '>0');
        if not Rec.IsEmpty then
            IF CONFIRM('Confirm the order ?', TRUE) THEN
                ConfirmOrder := true;

        IF ConfirmOrder THEN
            IF Rec.FINDSET THEN BEGIN

                LunchOrder.FINDLAST;
                EntryNo := LunchOrder."Entry No.";

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

    var
        BoltText: Boolean;
        LunchOrder: Record "Lunch Order Entry";
        LunchMenu: Record "Lunch Menu";
        LastMenuDate: Date;

}
