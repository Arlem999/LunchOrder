tableextension 50115 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50100; "Reimbursable"; Boolean)
        {
            Caption = 'Reimbursable Arlem';
            DataClassification = ToBeClassified;
        }

        field(50101; "Receipt"; Text[512])
        {
            Caption = 'Receipt Arlem';
            DataClassification = ToBeClassified;
        }
    }
}
