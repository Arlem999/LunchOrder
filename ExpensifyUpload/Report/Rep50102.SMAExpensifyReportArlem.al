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
            DataItemTableView = sorting("Line No.");

            trigger OnPreDataItem()
            var
                ImportCSVFile: Codeunit ImportCSVFile;
            begin
                ImportCSVFile.LoadCSVData(TemplateName, BatchName, StartDate, EndingDate);
            end;
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
                    field(TemplateName; TemplateName)
                    {
                        TableRelation = "Gen. Journal Template";
                    }
                    field(BatchName; BatchName)
                    {
                        TableRelation = "Gen. Journal Batch";
                    }
                    field(StartDate; StartDate)
                    {
                    }
                    field(EndingDate; EndingDate)
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
        TemplateName: Code[10];
        BatchName: Code[10];
        StartDate: Date;
        EndingDate: Date;
        Txt001: Label 'File imported successfully';

    trigger OnPostReport()
    begin
        Message(Txt001);
    end;
}
