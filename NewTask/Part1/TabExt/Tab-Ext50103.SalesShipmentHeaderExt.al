tableextension 50103 "Sales Shipment Header Ext" extends "Sales Shipment Header"
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
