pageextension 50115 "Purchase Return Order Ext" extends "Purchase Return Order"
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
