tableextension 50108 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50100; "Number of lines"; Integer)
        {
            Caption = 'Number of lines';
            MinValue = 1;
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document No." = field("No."), "Document Type" = field("Document Type")));
        }
    }
}
