page 50103 "SMA Expensify Integr. Setup"
{
    Caption = 'SMA Expensify Integr. Setup';
    PageType = Card;
    SourceTable = "SMA Expensify Integr. Setup";

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
                    Editable = true;
                }
                field(PartnerUserSecret; Rec.PartnerUserSecret)
                {
                    ApplicationArea = All;
                    Caption = 'Partner User Secret';
                    Editable = true;
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
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                InFooterBar = true;
                trigger OnAction();
                begin
                    Rec.Init();
                    Message('Test');
                    Rec.Insert();
                end;
            }
        }
    }
}
