table 50132 "Lunch Order Entry"
{
    Caption = 'Lunch Order Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Resourse No."; Code[20])
        {
            Caption = 'Resourse No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Menu Item Entry No."; Integer)
        {
            Caption = 'Menu Item Entry No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Menu Item No."; Code[20])
        {
            Caption = 'Menu Item No.';
            DataClassification = ToBeClassified;
        }
        field(7; "Item Description"; Text[250])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(9; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(11; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = Created,"Sent to Vendor",Posted;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
