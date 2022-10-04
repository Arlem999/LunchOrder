pageextension 50126 "Vendor Ledger Entries Ext" extends "Vendor Ledger Entries"
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
