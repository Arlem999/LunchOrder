pageextension 50107 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
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
