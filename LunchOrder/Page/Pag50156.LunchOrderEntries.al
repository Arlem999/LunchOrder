page 50156 "Lunch Order Entries"
{
    ApplicationArea = All;
    Caption = 'Lunch Order Entries';
    PageType = List;
    SourceTable = "Lunch Order Entry";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Resourse No."; Rec."Resourse No.")
                {
                    ApplicationArea = All;
                }
                field("Menu Item Entry No."; Rec."Menu Item Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    TableRelation = Vendor."No." where("Lunch Vendor" = const(true));
                }
                field("Menu Item No."; Rec."Menu Item No.")
                {
                    ApplicationArea = All;
                    TableRelation = "Lunch Item"."Item No." where("Item No." = field("Menu Item No."));
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                Image = Dimensions;
                ShortCutKey = "Shift+Ctrl+D";
                ApplicationArea = All;
                Caption = 'Dimensions';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
        }
    }
}