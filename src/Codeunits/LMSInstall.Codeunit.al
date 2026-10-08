codeunit 50100 "LMS Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        SetupData: Codeunit "LMS Setup Data";
    begin
        SetupData.InsertDefaults();
    end;
}
