pageextension 50102 "Sales Order Ext" extends "Sales Order"
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
