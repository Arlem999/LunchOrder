pageextension 50117 "Posted Purchase Credit Memo Ex" extends "Posted Purchase Credit Memo"
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
