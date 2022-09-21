pageextension 50102 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {

            field("Custom Posting Description ARLEM"; Rec."Posting Description ARLEM")
            {
                ApplicationArea = All;
                Caption = 'Custom ARLEM Posting Description';
                ShowMandatory = true;

                trigger OnValidate()
                begin
                    Rec.TestField("Posting Description ARLEM");
                end;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(Wizard)
            {
                ApplicationArea = All;
                Caption = 'Wizard Arlem';
                Image = FiledPosted;
                RunObject = page "Custom Posting Arlem";
                RunPageLink = "No." = field("No.");
            }
        }
    }
}
