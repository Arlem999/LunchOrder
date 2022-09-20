tableextension 50111 "Purch. Rcpt. Header Ext" extends "Purch. Rcpt. Header"
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
