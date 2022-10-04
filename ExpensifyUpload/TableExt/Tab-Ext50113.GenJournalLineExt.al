tableextension 50113 "Gen. Journal Line Ext" extends "Gen. Journal Line"
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
