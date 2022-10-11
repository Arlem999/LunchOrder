table 50101 "SMA Expensify Integr. Setup"
{
    Caption = 'SMA Expensify Integr. Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(2; PartnerUserID; Code[30])
        {
            Caption = 'Partner User ID';
            DataClassification = SystemMetadata;
        }
        field(3; PartnerUserSecret; Code[30])
        {
            Caption = 'Partner User Secret';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}