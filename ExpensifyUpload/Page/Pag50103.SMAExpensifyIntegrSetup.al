page 50103 "SMA Expensify Integr. Setup"
{
    Caption = 'SMA Expensify Integr. Setup Arlem';
    PageType = Card;
    SourceTable = "SMA Expensify Integr. Setup";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Enter a value and click Save")
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
                    ExtendedDatatype = Masked;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Get_API_Expencify_Arlem)
            {
                ApplicationArea = All;
                Caption = 'Get API Expencify Arlem';
                Image = GetBinContent;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;
                RunObject = report "SMA Expensify Report Arlem";
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then
            Rec.Insert(true)
    end;
}
