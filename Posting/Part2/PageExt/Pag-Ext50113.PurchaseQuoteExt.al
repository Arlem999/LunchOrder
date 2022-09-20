pageextension 50113 "Purchase Quote Ext" extends "Purchase Quote"
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
