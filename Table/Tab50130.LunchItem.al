table 50130 "Lunch Item"
{
    Caption = 'Lunch Item';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where("Lunch Vendor" = const(true));
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Item No." <> xRec."Item No." THEN BEGIN
                    SalesReceivablesSetup.GET;
                    NoSeriesMgt.TestManual(SalesReceivablesSetup."Lunch Item Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; Weight; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(5; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
        }
        field(6; Picture; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
        }
        field(7; "Info Link"; Text[250])
        {
            Caption = 'Info Link';
            DataClassification = ToBeClassified;
        }
        field(8; "Self Order"; Boolean)
        {
            Caption = 'Self Order';
            DataClassification = ToBeClassified;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,1,1';

            trigger OnValidate()

            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionClass = '1,1,2';

            trigger OnValidate()

            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }

    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        IF "Item No." = '' THEN BEGIN
            SalesReceivablesSetup.GET;
            SalesReceivablesSetup.TESTFIELD("Lunch Item Nos.");
            NoSeriesMgt.InitSeries(
              SalesReceivablesSetup."Lunch Item Nos.", xRec."Item No.", 0D, "Item No.", "No. Series");
        END;

        DimMgt.UpdateDefaultDim(DATABASE::"Lunch Item", "Item No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Lunch Item", "Item No.");
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        "No. Series": Code[20];
        DimMgt: Codeunit DimensionManagement;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Lunch Item", "Item No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
}
