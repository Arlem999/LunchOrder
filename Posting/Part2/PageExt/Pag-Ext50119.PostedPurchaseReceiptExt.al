pageextension 50119 "Posted Purchase Receipt Ext" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Responsibility Center")
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
