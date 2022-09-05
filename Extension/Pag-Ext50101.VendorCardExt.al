pageextension 50101 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addafter("Disable Search by Name")
        {

            field("Lunch Vendor"; Rec."Lunch Vendor")
            {
                ApplicationArea = All;
                Caption = 'Lunch Vendor';
            }
        }
    }
}
