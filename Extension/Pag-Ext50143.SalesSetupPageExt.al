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
            }

        }
    }
}
