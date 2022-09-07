page 50151 "Lunch Item Card"
{
    Caption = 'Lunch Item Card';
    PageType = Card;
    SourceTable = "Lunch Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    Caption = 'Weight';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    Caption = 'Price';
                }
                field("Info Link"; Rec."Info Link")
                {
                    ApplicationArea = All;
                    Caption = 'Info Link';
                }
                field("Self Order"; Rec."Self Order")
                {
                    ApplicationArea = All;
                    Caption = 'Self Order';
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Item Lunch Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "Item No." = field("Item No.");
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
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = CONST(50130), "No." = FIELD("Item No.");

            }
        }
    }
}
