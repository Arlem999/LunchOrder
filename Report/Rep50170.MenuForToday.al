report 50170 "Menu For Today"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report.rdl';
    ApplicationArea = All;
    Caption = 'Menu For Today';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(LunchMenu; "Lunch Menu")
        {

            DataItemTableView = sorting("Menu Date");

            column(MenuDate_LunchMenu; "Menu Date")
            {

            }
            column(ItemNo_LunchMenu; "Item No.")
            {

            }
            column(Weight_LunchMenu; Weight)
            {

            }
            column(Price_LunchMenu; Price)
            {

            }
            column(Description; "Item Description")
            {

            }
            column(MenuDate; MenuDate)
            {

            }
            trigger OnPreDataItem()

            begin
                LunchMenu.SetRange("Menu Date", MenuDate);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Select a date: ")
                {
                    field(MenuDate; MenuDate)
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
    var
        MenuDate: Date;
}
