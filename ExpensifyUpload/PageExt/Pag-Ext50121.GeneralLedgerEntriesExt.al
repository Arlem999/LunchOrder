pageextension 50125 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {

            field(Reimbursable; Rec."Reimbursable")
            {
                ApplicationArea = All;
                Caption = 'Reimbursable Arlem';
            }
            field(Receipt; Rec."Receipt")
            {
                ApplicationArea = All;
                Caption = 'Receipt Arlem';
            }
        }
    }
}