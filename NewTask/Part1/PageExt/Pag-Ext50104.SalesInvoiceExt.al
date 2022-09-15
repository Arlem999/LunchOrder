pageextension 50104 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(Status)
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = '"Custom ARLEM Posting Description"';
            }
        }
    }
}
