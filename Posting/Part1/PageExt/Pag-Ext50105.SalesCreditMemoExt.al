pageextension 50105 "Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = 'Custom ARLEM Posting Description';
            }
        }
    }
}
