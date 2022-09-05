page 50153 "Lunch Vendor List"
{
    Caption = 'Lunch Vendor List';
    PageType = List;
    SourceTable = Vendor;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Lunch Vendor Card";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                }
                field("Lunch Vendor"; Rec."Lunch Vendor")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
