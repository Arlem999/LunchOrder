codeunit 50102 ImportExcelFile
{
    var
        UploadMessage: Label 'Please Choose the Excel File: ';
        NoFileFoundMsg: Label 'File Not Found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: text;
        SheetName: Text;

    procedure ReadExelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
    begin
        UploadIntoStream(UploadMessage, '', '', FromFile, IStream);
        If FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure ImportExcelData()
    var
        GenJournal: Record "Gen. Journal Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        GenJournal.Reset();
        if GenJournal.FindLast() then
            LineNo := GenJournal."Line No.";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            if GetValueAtCell(RowNo, 1) <> '' then begin
                LineNo := LineNo + 10000;
                GenJournal.Init();
                GenJournal."Line No." := LineNo;
                Evaluate(GenJournal."External Document No.", GetValueAtCell(RowNo, 1));
                Evaluate(GenJournal."Account No.", GetValueAtCell(RowNo, 2));
                Evaluate(GenJournal."Posting Date", GetValueAtCell(RowNo, 3));
                Evaluate(GenJournal."Amount (LCY)", GetValueAtCell(RowNo, 4));
                Evaluate(GenJournal."Shortcut Dimension 1 Code", '000' + (GetValueAtCell(RowNo, 5)) +
                 '.00' + GetValueAtCell(RowNo, 7) + '.0' + GetValueAtCell(RowNo, 9));
                GenJournal.Description := GetValueAtCell(RowNo, 11);
                GenJournal.Insert();
            end;
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}
