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
                NotBlank = true;

                // trigger OnValidate()
                // var
                //     myInt: Integer;
                // begin
                //     if Rec.FindSet() then begin
                //         repeat
                //             if Rec."Posting Description ARLEM" <> '' then
                //                 Message(Rec."Posting Description ARLEM");
                //         UNTIL Rec.NEXT = 0;
                //     end;
                // end;
            }
        }
    }
}
