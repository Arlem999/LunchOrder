report 50101 ReportBuilderManage
{
    ApplicationArea = All;
    Caption = 'ReportBuilderManage';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Sales_Header; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                trigger OnPostDataItem()
                begin
                    FillLine();
                    FillFooter();
                end;

                trigger OnPreDataItem()
                begin
                    FillHeader();
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Order No.: ")
                {
                    field("Order No."; Sales_Header."No.")
                    {
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        InitReportTemplate();
    end;

    trigger OnPostReport()
    begin
        ExportData();
    end;

    var
        CompanyInfo: Record "Company Information";
        ExcelReportBuilderManager: Codeunit "Excel Report Builder Manager";
        Customer: Record Customer;

    procedure InitReportTemplate()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("Report Arlem");
        ExcelReportBuilderManager.InitTemplate(SalesReceivablesSetup."Report Arlem");
        ExcelReportBuilderManager.SetSheet('Report');
    end;

    local procedure FillHeader()
    var
        CustomerNo: code[20];
    begin
        CustomerNo := Sales_Header."Sell-to Customer No.";
        CompanyInfo.Get();
        Customer.SetRange("No.", CustomerNo);
        if Customer.FindFirst() then begin
            ExcelReportBuilderManager.AddSection('REPORTHEADER');

            ExcelReportBuilderManager.AddDataToSection('Company_Name', CompanyInfo.Name);
            ExcelReportBuilderManager.AddDataToSection('Address', CompanyInfo.Address);
            ExcelReportBuilderManager.AddDataToSection('Registration_No', CompanyInfo."Registration No.");
            ExcelReportBuilderManager.AddDataToSection('Customer_Name', Customer.Name);
            ExcelReportBuilderManager.AddDataToSection('Ship_to_Code', Customer."Ship-to Code");
            ExcelReportBuilderManager.AddDataToSection('Mobile_Phone_No.', Customer."Mobile Phone No.");
        end;
    end;

    local procedure FillLine()
    begin
        if SalesLine.Type <> SalesLine.Type::" " then begin
            ExcelReportBuilderManager.AddSection('BODY');

            ExcelReportBuilderManager.AddDataToSection('Product_Сode', SalesLine."No.");
            ExcelReportBuilderManager.AddDataToSection('Description', SalesLine.Description);
            ExcelReportBuilderManager.AddDataToSection('Quantity', Format(SalesLine.Quantity));
            ExcelReportBuilderManager.AddDataToSection('Unit_Price', Format(SalesLine."Unit Cost"));
            ExcelReportBuilderManager.AddDataToSection('Base_Unit_of_Measure', SalesLine."Unit of Measure");
            ExcelReportBuilderManager.AddDataToSection('Amount_per_line', Format(SalesLine."Unit Cost" * SalesLine.Quantity));
        end;
    end;

    procedure FillFooter()
    begin
        ExcelReportBuilderManager.AddDataToSection('Order_amount_without_VAT', Format(Sales_Header.Amount));
        ExcelReportBuilderManager.AddDataToSection('VAT_amount_on_the_order', Format(Sales_Header."Amount Including VAT" - Sales_Header.Amount));
        ExcelReportBuilderManager.AddDataToSection('Order_amount_with_VAT', Format(Sales_Header."Amount Including VAT"));
        ExcelReportBuilderManager.AddDataToSection('OrderDate', Format(Sales_Header."Order Date"));
    end;

    procedure ExportData()
    begin
        ExcelReportBuilderManager.ExportData;
    end;
}
