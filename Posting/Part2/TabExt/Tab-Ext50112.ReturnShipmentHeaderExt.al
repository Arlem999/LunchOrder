tableextension 50112 "Return Shipment Header Ext" extends "Return Shipment Header"
{
    fields
    {
        field(50100; "Number of lines"; Integer)
        {
            Caption = 'Number of lines';
            TableRelation = "Purchase Header"."Number of lines" where("No." = field("No."));
        }
    }
}
