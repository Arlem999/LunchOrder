tableextension 50104 "Sales Invoice Header Ext" extends "Sales Invoice Header"
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
