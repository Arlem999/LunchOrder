page 50152 "Lunch Menu Edit"
{
    Caption = 'Lunch Menu Edit';
    PageType = List;
    SourceTable = "Lunch Menu";
    AutoSplitKey = true;
    Editable = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Date"; Rec."Menu Date")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = All;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Order Quantity"; Rec."Order Quantity")
                {
                    ApplicationArea = All;
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                }
                field("Previos Quantity"; Rec."Previos Quantity")
                {
                    ApplicationArea = All;
                }
                field("Self Order"; Rec."Self Order")
                {
                    ApplicationArea = All;
                }
                field("Parent Menu Item No."; Rec."Parent Menu Item No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
