pageextension 50114 "Purchase Order Ext" extends "Purchase Order"
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
