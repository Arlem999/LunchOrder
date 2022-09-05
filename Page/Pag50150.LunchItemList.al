page 50150 "Lunch Item List"
{
    Caption = 'Lunch Item List';
    PageType = List;
    SourceTable = "Lunch Item";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Lunch Item Card";

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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                }
                field("Info Link"; Rec."Info Link")
                {
                    ApplicationArea = All;
                }
                field("Self Order"; Rec."Self Order")
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
            group(Dimensions)
            {
                action("Dimensions-Single")
                {
                    Image = Dimensions;
                    ShortCutKey = "Shift+Ctrl+D";
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(50130), "No." = FIELD("Item No.");
                }
                action("Dimensions-Multiple")

                {
                    ApplicationArea = all;
                    Image = Dimensions;
                    ShortCutKey = "Shift+Ctrl+D";
                    Caption = 'Dimensions-Multiple';
                    RunObject = Page "Default Dimensions-Multiple";
                    RunPageLink = "Table ID" = CONST(50130), "No." = FIELD("Item No.");

                    trigger OnAction()
                    var
                        LunchItem: Record "Lunch Item";
                        DefaultDimMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SETSELECTIONFILTER(LunchItem);
                        DefaultDimMultiple.SetRecord(LunchItem);
                        DefaultDimMultiple.RUNMODAL;
                    end;
                }
            }
        }
    }
}
