tableextension 50107 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "Posting Description ARLEM"; Text[250])
        {
            Caption = 'Custom Posting Description ARLEM';
            DataClassification = ToBeClassified;
        }
    }
}
