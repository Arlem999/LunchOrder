pageextension 50120 "General Journal Ext" extends "General Journal"
{
    actions
    {
        addafter("Reconcile")
        {
            action(Portfolio_Arlem)
            {
                ApplicationArea = All;
                Caption = 'Portfolio_Arlem';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ImportExcelFile: Codeunit ImportExcelFile;
                begin
                    ImportExcelFile.ReadExelSheet();
                    ImportExcelFile.ImportExcelData();
                end;
            }
        }

        addafter(Portfolio_Arlem)
        {
            action(Collection_Arlem)
            {
                ApplicationArea = All;
                Caption = 'Collection_Arlem';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ImportExcelFile: Codeunit ImportExcelFile;
                begin
                    ImportExcelFile.ReadExelSheet();
                    ImportExcelFile.ImportExcelData();
                end;
            }
        }
    }

}
