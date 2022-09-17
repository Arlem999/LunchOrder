pageextension 50108 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("External Document No.")
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = '"Custom ARLEM Posting Description"';
                Editable = false;
            }
        }
    }
}
