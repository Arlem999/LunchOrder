table 50101 "SMA Expensify Integr. Setup"
{
    Caption = 'SMA Expensify Integr. Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PartnerUserID; Integer)
        {
            Caption = 'Partner User ID';
            DataClassification = ToBeClassified;
        }
        field(2; PartnerUserSecret; Code[30])
        {
            Caption = 'Partner User Secret';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "PartnerUserID")
        {
            Clustered = true;
        }
    }
}