pageextension 50109 "Posted Sales Shipment Ext" extends "Posted Sales Shipment"
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
