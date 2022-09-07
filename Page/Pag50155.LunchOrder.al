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
                    TableRelation = Vendor."No." where("Lunch Vendor" = const(true));


                    trigger OnValidate()
                    begin
                        Rec.DELETEALL;
                        LunchMenu.SetFilter("Vendor No.", Rec."Vendor No.");
                        LunchMenu.FINDLAST;
                        LunchMenu.SETRANGE("Menu Date", LunchMenu."Menu Date");

                        IF LunchMenu.FINDSET THEN
                            REPEAT
                                Rec.INIT;
                                Rec := LunchMenu;
                                Rec.INSERT;
                            UNTIL LunchMenu.NEXT = 0;

                        LunchMenu.SetRange("Menu Date");
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
    begin
        ConfirmOrder.SaveOrder(Rec);
    end;

    var
        BoltText: Boolean;
        LunchMenu: Record "Lunch Menu";
        ConfirmOrder: Codeunit ConfirmOrder;
}
