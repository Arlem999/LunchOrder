pageextension 50120 "General Journal Ext" extends "General Journal"
{
    layout
    {
        addafter("Document No.")
        {

            field(Reimbursable; Rec."Reimbursable")
            {
                ApplicationArea = All;
                Caption = 'Reimbursable';
            }
            field(Receipt; Rec."Receipt")
            {
                ApplicationArea = All;
                Caption = 'Receipt';
            }
        }
    }

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
                    ImportExcelFile.ImportExcelData(Rec);
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
                    ImportTxtFile: Codeunit "Import Txt File";
                begin
                    ImportTxtFile.ReadTxtFile();
                    ImportTxtFile.ImportTxtData(Rec);
                end;
            }
        }
        addafter("Reconcile")
        {
            action(Expensify_Upload_Arlem)
            {
                ApplicationArea = All;
                Caption = 'Expensify_upload_Arlem';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ImportCSVFile: Codeunit ImportCSVFile;
                begin
                    ImportCSVFile.ReadCSVFile();
                    //  ImportCSVFile.ImportCSVData(Rec);
                end;
            }
        }
    }
}