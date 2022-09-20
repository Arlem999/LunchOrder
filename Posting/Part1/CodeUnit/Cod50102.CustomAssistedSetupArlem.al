codeunit 50102 "Custom Assisted Setup Arlem"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)]
    local procedure AddGeneralLedgerSetupWizard()
    var
        AssistedSetup: Codeunit "Guided Experience";
        Language: Codeunit Language;
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage;
        AssistedSetup.InsertAssistedSetup(SetupTxt, SetupTxt, SetupTxt, 1000, ObjectType::Page, Page::"Custom Posting Arlem",
                        "Assisted Setup Group"::GettingStarted, 'https://www.youtube.com/embed/hRLjl2u4I0w',
                        "Video Category"::Uncategorized,
                        'https://docs.microsoft.com/en-us/training/modules/build-assisted-setup/5-exercise');

        GlobalLanguage(Language.GetDefaultApplicationLanguageId());
        AssistedSetup.AddTranslationForSetupObjectDescription(Enum::"Guided Experience Type"::"Assisted Setup",
        ObjectType::Page, Page::"Custom Posting Arlem", Language.GetDefaultApplicationLanguageId(), SetupTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    var
        Info: ModuleInfo;
        SetupTxt: Label 'Set Up Custom descript. Arlem';
}