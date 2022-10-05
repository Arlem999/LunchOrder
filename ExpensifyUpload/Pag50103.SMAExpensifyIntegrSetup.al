page 50103 "SMA Expensify Integr. Setup"
{
    Caption = 'SMA Expensify Integr. Setup';
    PageType = Card;
    SourceTable = "SMA Expensify Integr. Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PartnerUserID; Rec.PartnerUserID)
                {
                    ApplicationArea = All;
                    Caption = 'Partner User ID';
                }
                field(PartnerUserSecret; Rec.PartnerUserSecret)
                {
                    ApplicationArea = All;
                    Caption = 'Partner User Secret';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Save)
            {

            }
        }
    }
}
