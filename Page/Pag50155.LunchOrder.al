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
                    Editable = true;
                    Enabled = true;
                    Visible = true;
                    QuickEntry = true;


                    trigger OnValidate()
                    var
                        VendorNo: code[30];
                    begin
                        Rec.DELETEALL;
                        BEGIN
                            VendorNo := Rec."Vendor No.";
                            LunchMenu.SETRANGE("Vendor No.", VendorNo);
                            LunchMenu.FINDLAST;
                            LastMenuDate := LunchMenu."Menu Date";
                        END;
                        BEGIN
                            LunchMenu.SETRANGE("Vendor No.", VendorNo);
                            LunchMenu.SETRANGE("Menu Date", LastMenuDate);
                            IF LunchMenu.FINDSET THEN
                                REPEAT
                                    Rec.INIT;
                                    Rec := LunchMenu;
                                    Rec.INSERT;
                                UNTIL LunchMenu.NEXT = 0;
                        END;
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
            action("Report")
            {
                ApplicationArea = all;
                Caption = 'Report';
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
        ConfirmRecord: Boolean;
        EntryNo: Integer;
    begin
        if Rec.FINDSET then
            REPEAT
                IF Rec."Order Quantity" <> 0 THEN
                    IF CONFIRM('Confirm the order ' + Rec."Item Description" + '?', TRUE) THEN
                        ConfirmRecord := TRUE;
            UNTIL Rec.NEXT = 0;

        IF ConfirmRecord THEN
            IF Rec.FINDSET THEN BEGIN

                LunchOrder.FINDLAST;
                EntryNo := LunchOrder."Entry No.";

                REPEAT
                    IF Rec."Order Quantity" <> Rec."Previos Quantity" THEN BEGIN

                        LunchOrder.SETRANGE("Vendor No.", Rec."Vendor No.");
                        LunchOrder.SETRANGE("Order Date", Rec."Menu Date");
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
                            LunchOrder.Amount := Rec."Order Amount";
                            LunchOrder."Order Date" := Rec."Menu Date";
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
