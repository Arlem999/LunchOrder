tableextension 50102 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
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
