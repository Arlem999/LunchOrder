report 50102 "SMA Expensify Report Arlem"
{
    ApplicationArea = All;
    Caption = 'SMA Expensify Report Arlem';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Enter the required information:")
                {
                    field("Order No."; GenJournalLine."Journal Template Name")
                    {
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
