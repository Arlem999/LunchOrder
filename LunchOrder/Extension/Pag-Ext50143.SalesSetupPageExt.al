pageextension 50143 SalesSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {

            field("Lunch Item Nos."; Rec."Lunch Item Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lunch Item Nos. field.';
                Caption = 'Lunch Item Nos.';
            }
            field("Lunch Vendor Nos."; "Lunch Vendor Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lunch Vendor Nos. field.';
                Caption = 'Lunch Vendor Nos.';
            }
        }

        addafter("Freight G/L Acc. No.")
        {
            field("Report Arlem"; "Report Arlem")
            {
                Caption = 'Report Arlem';
                ApplicationArea = All;
            }
        }
    }
}
