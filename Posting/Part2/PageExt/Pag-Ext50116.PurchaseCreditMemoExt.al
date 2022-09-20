pageextension 50116 "Purchase Credit Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter(Status)
        {

            field("Number of lines Arlem"; Rec."Number of lines")
            {
                ApplicationArea = All;
                Caption = 'Number of lines Arlem';
                Editable = false;
                TableRelation = "Purchase Line";
            }
        }
    }
}
