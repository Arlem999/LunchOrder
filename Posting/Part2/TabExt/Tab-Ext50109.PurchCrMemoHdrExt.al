tableextension 50109 "Purch. Cr. Memo Hdr. Ext" extends "Purch. Cr. Memo Hdr."
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
