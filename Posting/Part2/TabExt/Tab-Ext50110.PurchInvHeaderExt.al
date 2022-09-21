tableextension 50110 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "Number of lines"; Integer)
        {
            Caption = 'Number of lines';
            TableRelation = "Purchase Header"."Number of lines" where("No." = field("Order No."));
        }
        field(50101; "Posting Description ARLEM"; Text[250])
        {
            Caption = 'Custom Posting Description ARLEM';
            DataClassification = ToBeClassified;
        }
    }
}
