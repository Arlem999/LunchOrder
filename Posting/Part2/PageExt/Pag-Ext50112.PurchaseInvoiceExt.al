pageextension 50112 "Purchase Invoice Ext" extends "Purchase Invoice"
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
