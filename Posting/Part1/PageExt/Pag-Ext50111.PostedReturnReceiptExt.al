pageextension 50111 "Posted Return Receipt Ext" extends "Posted Return Receipt"
{
    layout
    {
        addafter("External Document No.")
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = 'Custom ARLEM Posting Description';
                Editable = false;
            }
        }
    }
}
