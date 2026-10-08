/// <summary>
/// Good Distribution Practice (GDP) style rules for pharmaceutical and healthcare products:
/// full batch traceability, expiry dates, short-dated stock warnings and controlled temperature.
/// </summary>
codeunit 50121 "LMS Pharma Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    var
        RuleTxt: Label 'Pharma (GDP)', Locked = true;
        LotErr: Label 'Line %1 (%2): pharmaceutical goods require a batch/lot number.', Comment = '%1 = line no., %2 = description';
        ExpiryErr: Label 'Line %1 (%2): pharmaceutical goods require an expiration date.', Comment = '%1 = line no., %2 = description';
        ShortDatedMsg: Label 'Line %1 (%2): short-dated stock, expires on %3.', Comment = '%1 = line no., %2 = description, %3 = date';
        NoTempMsg: Label 'Line %1 (%2): no temperature range defined. GDP requires controlled conditions (typically 15-25°C or 2-8°C).', Comment = '%1 = line no., %2 = description';
        HazardMixMsg: Label 'Pharmaceutical goods are shipped together with hazardous goods. Verify segregation requirements.';

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        LMSSetup: Record "LMS Setup";
        ShipmentLine: Record "LMS Shipment Line";
    begin
        LMSSetup.GetRecordOnce();
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if ShipmentLine.FindSet() then
            repeat
                if not ShipmentLine.Hazardous then begin
                    if ShipmentLine."Lot No." = '' then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(LotErr, ShipmentLine."Line No.", ShipmentLine.Description));
                    if ShipmentLine."Expiration Date" = 0D then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(ExpiryErr, ShipmentLine."Line No.", ShipmentLine.Description))
                    else
                        if (ShipmentLine."Expiration Date" >= ShipmentHeader."Shipment Date") and
                           (ShipmentLine."Expiration Date" - ShipmentHeader."Shipment Date" <= LMSSetup."Expiry Warning Days")
                        then
                            TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(ShortDatedMsg, ShipmentLine."Line No.", ShipmentLine.Description, ShipmentLine."Expiration Date"));
                    if not ShipmentLine."Temperature Controlled" then
                        TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(NoTempMsg, ShipmentLine."Line No.", ShipmentLine.Description));
                end;
            until ShipmentLine.Next() = 0;

        ShipmentLine.SetRange(Hazardous, true);
        if not ShipmentLine.IsEmpty() then begin
            ShipmentLine.SetRange(Hazardous, false);
            if not ShipmentLine.IsEmpty() then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, RuleTxt, HazardMixMsg);
        end;
    end;
}
