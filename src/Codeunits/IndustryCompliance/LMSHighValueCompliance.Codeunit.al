/// <summary>
/// Rules for high-value goods (electronics, automotive parts and vehicles): serialised traceability,
/// declared values for insurance and liability, and insurance cover.
/// </summary>
codeunit 50124 "LMS High Value Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    var
        RuleTxt: Label 'High Value', Locked = true;
        SerialErr: Label 'Line %1 (%2): high-value goods require a serial number.', Comment = '%1 = line no., %2 = description';
        DeclaredValueErr: Label 'Line %1 (%2): a declared value is required for liability and insurance.', Comment = '%1 = line no., %2 = description';
        NoInsuranceMsg: Label 'Industry profile %1 requires insurance, but no insurance amount is calculated. Check the insurance rate on the goods types.', Comment = '%1 = profile';
        UnattendedMsg: Label 'High-value goods: no driver is assigned. Assign a vetted driver before dispatch.';

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        IndustryProfile: Record "LMS Industry Profile";
        ShipmentLine: Record "LMS Shipment Line";
        HasHighValue: Boolean;
    begin
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if ShipmentLine.FindSet() then
            repeat
                if ShipmentLine."Declared Value" = 0 then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(DeclaredValueErr, ShipmentLine."Line No.", ShipmentLine.Description));
                if ShipmentLine."Handling Class" = ShipmentLine."Handling Class"::"High Value" then begin
                    HasHighValue := true;
                    if ShipmentLine."Serial No." = '' then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(SerialErr, ShipmentLine."Line No.", ShipmentLine.Description));
                end;
            until ShipmentLine.Next() = 0;

        if HasHighValue and (ShipmentHeader."Driver No." = '') and (ShipmentHeader."Vehicle No." <> '') then
            TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, RuleTxt, UnattendedMsg);

        if IndustryProfile.Get(ShipmentHeader."Industry Code") then
            if IndustryProfile."Requires Insurance" and (ShipmentHeader."Insurance Amount" = 0) and (ShipmentHeader."Total Declared Value" > 0) then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, RuleTxt, StrSubstNo(NoInsuranceMsg, IndustryProfile.Code));
    end;
}
