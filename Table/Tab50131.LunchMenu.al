table 50131 "Lunch Menu"
{
    Caption = 'Lunch Menu';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where("Lunch Vendor" = const(true));

            trigger OnValidate()
            begin
                CreateDim(DATABASE::Vendor, "Vendor No.",
                             DATABASE::"Lunch Item", "Item No.");
            end;
        }
        field(2; "Menu Date"; Date)
        {
            Caption = 'Menu Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = "Lunch Item";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                ItemRec: Record "Lunch Item";
            begin
                IF ItemRec.GET("Item No.") THEN BEGIN
                    Weight := ItemRec.Weight;
                    "Item Description" := ItemRec.Description;
                    Price := ItemRec.Price;
                    "Self Order" := ItemRec."Self Order";
                END;

                CreateDim(DATABASE::Vendor, "Vendor No.",
                             DATABASE::"Lunch Item", "Item No.");
            end;

        }
        field(5; "Item Description"; Text[250])
        {
            Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(6; Weight; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(7; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
        }
        field(8; Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = ToBeClassified;
        }
        field(9; "Menu Item Entry No."; Integer)
        {
            Caption = 'Menu Item Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(10; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = ToBeClassified;
        }
        field(11; "Order Quantity"; Decimal)
        {
            Caption = 'Order Quantity';
            DataClassification = ToBeClassified;
            MinValue = 0;
            DecimalPlaces = 0;
        }
        field(12; "Order Amount"; Decimal)
        {
            Caption = 'Order Amount';
            DataClassification = ToBeClassified;
        }
        field(13; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionMembers = Item,"Group Heading";
            DataClassification = ToBeClassified;
        }
        field(14; "Previos Quantity"; Decimal)
        {
            Caption = 'Previos Quantity';
            FieldClass = FlowField;
            MinValue = 0;
            CalcFormula = Sum("Lunch Order Entry".Quantity WHERE("Menu Item Entry No." = field("Menu Item Entry No.")));
        }
        field(15; "Self Order"; Boolean)
        {
            Caption = 'Self Order';
            DataClassification = ToBeClassified;
        }
        field(16; "Parent Menu Item No."; Integer)
        {
            Caption = 'Parent Menu Item No.';
            DataClassification = ToBeClassified;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,1,1';

            trigger OnValidate()

            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(18; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,1,2';

            trigger OnValidate()

            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(19; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()

            begin
                ShowDimensions();
            end;
        }
    }
    keys
    {
        key(PK; "Vendor No.", "Menu Date", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()

    begin
        "Dimension Set ID" := DimMgt.EditDimensionSet
        ("Dimension Set ID", STRSUBSTNO('%1', "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code",
         "Shortcut Dimension 2 Code");
    end;

    local procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])

    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: Array[10] of Integer;
        No: array[10] of Code[20];

    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        TableID[2] := Type2;
        No[1] := No1;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';

        "Dimension Set ID" := DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup."General Journal", "Shortcut Dimension 1 Code",
       "Shortcut Dimension 2 Code", "Line No.", DATABASE::"Lunch Menu");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

}
