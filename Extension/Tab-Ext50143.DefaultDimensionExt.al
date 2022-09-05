tableextension 50143 "Default Dimension Ext" extends "Default Dimension"
{
    fields
    {

    }

    local procedure UpdateLunchItemGlobalDimCode(GlobalDimCodeNo: Integer; LunchItemNo: Code[20]; NewDimValue: Code[20])
    var
        LunchItem: Record "Lunch Item";
    begin
        IF LunchItem.GET(LunchItemNo) THEN BEGIN
            CASE GlobalDimCodeNo OF
                1:
                    LunchItem."Global Dimension 1 Code" := NewDimValue;
                2:
                    LunchItem."Global Dimension 2 Code" := NewDimValue;
                DATABASE::"Lunch Item":
                    UpdateLunchItemGlobalDimCode(GlobalDimCodeNo, "No.", NewDimValue);

            END;
        END;
    end;
}
