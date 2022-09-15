pageextension 50106 "Sales Return Order Ext" extends "Sales Return Order"
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
