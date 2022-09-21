pageextension 50110 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.")
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = 'Custom ARLEM Posting Description';
                ShowMandatory = true;
            }
        }
    }
}
