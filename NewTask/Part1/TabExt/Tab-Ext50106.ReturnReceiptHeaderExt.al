tableextension 50106 "Return Receipt Header Ext" extends "Return Receipt Header"
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
