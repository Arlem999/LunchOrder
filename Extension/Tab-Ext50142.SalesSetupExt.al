tableextension 50142 SalesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50101; "Lunch Item Nos."; code[20])
        {
            Caption = 'Lunch Item Nos.';
            TableRelation = "No. Series";
        }
        field(50102; "Lunch Vendor Nos."; code[20])
        {
            Caption = 'Lunch Vendor Nos.';
            TableRelation = "No. Series";
        }
    }
}

