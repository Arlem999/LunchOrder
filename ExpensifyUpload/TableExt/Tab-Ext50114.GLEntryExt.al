tableextension 50114 "G/L Entry Ext" extends "G/L Entry"
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
