page 50101 "Item Lunch Picture"
{
    Caption = 'Item Lunch Picture';
    PageType = CardPart;
    SourceTable = "Lunch Item";

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = All;
                Caption = 'Picture';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;

                trigger OnAction()

                begin
                    ImportFromDevice();
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    var
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        OverrideImageQst: Label 'The existing picture will be replaced. Continue?';
        DeleteExportEnabled: Boolean;

    procedure ImportFromDevice()
    var
        PicInStream: InStream;
        FromFileName: Text;
    begin
        Rec.TestField("Item No.");
        if Rec.Picture.Count() > 0 then
            if not Confirm(OverrideImageQst) then
                exit;

        if File.UploadIntoStream('Import', '', 'All Files (*.*)|*.*',
                                FromFileName, PicInStream) then begin
            Clear(Rec.Picture);
            Rec.Picture.ImportStream(PicInStream, FromFileName);
            Rec.Modify(true);
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Picture.Count <> 0;
    end;

    procedure DeleteItemPicture()
    begin
        Rec.TestField("Item No.");
        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Picture);
        Rec.Modify(true);
    end;
}
