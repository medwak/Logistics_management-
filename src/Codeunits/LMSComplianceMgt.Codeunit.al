/// <summary>
/// Compliance engine. Runs generic, data-driven checks (goods vs. vehicle, temperature, dangerous goods,
/// capacity, driver qualifications, industry-profile requirements, required documents), then the
/// industry-specific rules through the "LMS IIndustry Compliance" interface, then subscribers of
/// OnAfterCheckShipment. Never raises errors itself; it fills the issue buffer.
/// </summary>
codeunit 50103 "LMS Compliance Mgt."
{
    var
        GenericRuleTxt: Label 'General', Locked = true;
        VehicleRuleTxt: Label 'Vehicle', Locked = true;
        DriverRuleTxt: Label 'Driver', Locked = true;
        ProfileRuleTxt: Label 'Industry Profile', Locked = true;
        DocumentRuleTxt: Label 'Documents', Locked = true;
        NoIndustryErr: Label 'An industry profile must be specified on the shipment.';
        UnknownIndustryErr: Label 'Industry profile %1 does not exist.', Comment = '%1 = code';
        NoShipToErr: Label 'Ship-to name and city must be specified.';
        NoLinesErr: Label 'The shipment has no goods lines.';
        NoQuantityErr: Label 'Line %1 (%2): quantity must be greater than zero.', Comment = '%1 = line no., %2 = description';
        NoGoodsTypeMsg: Label 'Line %1 (%2): no goods type is specified; handling rules cannot be applied.', Comment = '%1 = line no., %2 = description';
        NoWeightMsg: Label 'Line %1 (%2): gross weight is zero; capacity and freight calculation may be inaccurate.', Comment = '%1 = line no., %2 = description';
        LotRequiredErr: Label 'Line %1 (%2): a lot/batch number is required by industry profile %3.', Comment = '%1 = line no., %2 = description, %3 = profile';
        SerialRequiredErr: Label 'Line %1 (%2): a serial number is required by industry profile %3.', Comment = '%1 = line no., %2 = description, %3 = profile';
        UNNumberErr: Label 'Line %1 (%2): hazardous goods require a UN number.', Comment = '%1 = line no., %2 = description';
        ExpiredErr: Label 'Line %1 (%2): goods expire on %3, before the shipment date.', Comment = '%1 = line no., %2 = description, %3 = date';
        ShelfLifeErr: Label 'Line %1 (%2): remaining shelf life is %3 days; goods type %4 requires at least %5 days.', Comment = '%1 = line no., %2 = description, %3 = days, %4 = goods type, %5 = min days';
        TariffMsg: Label 'Line %1 (%2): HS tariff number is missing for a cross-border shipment.', Comment = '%1 = line no., %2 = description';
        TempConflictErr: Label 'The goods on this shipment have incompatible temperature ranges (%1°C to %2°C). Split the shipment.', Comment = '%1 = min, %2 = max';
        TempRequiredByProfileMsg: Label 'Industry profile %1 requires temperature control but no goods line has a temperature range.', Comment = '%1 = profile';
        NoVehicleMsg: Label 'No vehicle is assigned; vehicle compatibility and capacity checks were skipped.';
        VehicleNotFoundErr: Label 'Vehicle %1 does not exist.', Comment = '%1 = vehicle no.';
        VehicleUnavailableErr: Label 'Vehicle %1 has status %2 and cannot be used.', Comment = '%1 = vehicle, %2 = status';
        VehicleOnTripMsg: Label 'Vehicle %1 is currently on another trip.', Comment = '%1 = vehicle';
        ModeMismatchErr: Label 'Vehicle %1 operates by %2 but the shipment transport mode is %3.', Comment = '%1 = vehicle, %2 = mode, %3 = mode';
        OverweightErr: Label 'Total weight %1 kg exceeds the payload of vehicle %2 (%3 kg).', Comment = '%1 = weight, %2 = vehicle, %3 = capacity';
        OvervolumeErr: Label 'Total volume %1 m³ exceeds the capacity of vehicle %2 (%3 m³).', Comment = '%1 = volume, %2 = vehicle, %3 = capacity';
        OverPalletsErr: Label 'Total pallets %1 exceed the capacity of vehicle %2 (%3).', Comment = '%1 = pallets, %2 = vehicle, %3 = capacity';
        NotReeferErr: Label 'Temperature-controlled goods require a temperature-controlled vehicle; vehicle %1 is not.', Comment = '%1 = vehicle';
        ReeferRangeErr: Label 'Vehicle %1 holds %2°C to %3°C, which does not cover the required %4°C to %5°C.', Comment = '%1 = vehicle, %2 = vehicle min. temp., %3 = vehicle max. temp., %4 = required min. temp., %5 = required max. temp.';
        NotHazmatVehicleErr: Label 'Hazardous goods require a hazmat-certified vehicle; vehicle %1 is not.', Comment = '%1 = vehicle';
        VehicleTypeNotAllowedErr: Label 'Line %1 (%2): goods type %3 may not be carried by a %4.', Comment = '%1 = line, %2 = description, %3 = goods type, %4 = vehicle type';
        VehicleInsuranceErr: Label 'The insurance of vehicle %1 expired on %2.', Comment = '%1 = vehicle, %2 = date';
        NoDriverMsg: Label 'No driver is assigned.';
        DriverNotFoundErr: Label 'Driver %1 does not exist.', Comment = '%1 = driver';
        DriverUnavailableErr: Label 'Driver %1 has status %2.', Comment = '%1 = driver, %2 = status';
        LicenseExpiredErr: Label 'The driving license of driver %1 expired on %2.', Comment = '%1 = driver, %2 = date';
        LicenseExpiringMsg: Label 'The driving license of driver %1 expires on %2.', Comment = '%1 = driver, %2 = date';
        DriverHazmatErr: Label 'Hazardous goods require a driver with a valid hazmat certificate; driver %1 does not have one.', Comment = '%1 = driver';
        TransitTooLongMsg: Label 'Route %1 takes %2 hours, more than the %3 hours allowed by industry profile %4.', Comment = '%1 = route, %2 = hours, %3 = max hours, %4 = profile';
        DocumentMissingErr: Label 'Required document %1 (%2) has not been received.', Comment = '%1 = code, %2 = description';

    procedure CheckShipment(var ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue"): Boolean
    var
        IndustryProfile: Record "LMS Industry Profile";
        IndustryCompliance: Interface "LMS IIndustry Compliance";
        Handled: Boolean;
    begin
        TempComplianceIssue.Reset();
        TempComplianceIssue.DeleteAll();

        OnBeforeCheckShipment(ShipmentHeader, TempComplianceIssue, Handled);
        if not Handled then begin
            ShipmentHeader.CalcFields("Total Gross Weight (kg)", "Total Volume (m3)", "Total Pallets", "Total Declared Value");

            if ShipmentHeader."Industry Code" = '' then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, GenericRuleTxt, NoIndustryErr)
            else
                if not IndustryProfile.Get(ShipmentHeader."Industry Code") then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", 0, GenericRuleTxt, StrSubstNo(UnknownIndustryErr, ShipmentHeader."Industry Code"));

            if (ShipmentHeader."Ship-to Name" = '') or (ShipmentHeader."Ship-to City" = '') then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, GenericRuleTxt, NoShipToErr);

            CheckLines(ShipmentHeader, IndustryProfile, TempComplianceIssue);
            CheckVehicle(ShipmentHeader, TempComplianceIssue);
            CheckDriver(ShipmentHeader, TempComplianceIssue);
            CheckRoute(ShipmentHeader, IndustryProfile, TempComplianceIssue);
            CheckDocuments(ShipmentHeader, TempComplianceIssue);

            IndustryCompliance := ShipmentHeader."Industry Type";
            IndustryCompliance.CheckShipment(ShipmentHeader, TempComplianceIssue);
        end;

        OnAfterCheckShipment(ShipmentHeader, TempComplianceIssue);
        exit(not TempComplianceIssue.HasErrors());
    end;

    /// <summary>
    /// Creates the shipment's required-document checklist from the industry profile (and the
    /// industry-independent entries with a blank industry code), according to each document's condition.
    /// Removes auto-generated documents that no longer apply and were not received yet.
    /// </summary>
    procedure RefreshRequiredDocuments(ShipmentHeader: Record "LMS Shipment Header")
    var
        IndustryDocument: Record "LMS Industry Document";
        ShipmentDocument: Record "LMS Shipment Document";
        RequiredCodes: List of [Code[20]];
    begin
        IndustryDocument.SetFilter("Industry Code", '%1|%2', '', ShipmentHeader."Industry Code");
        if IndustryDocument.FindSet() then
            repeat
                if IsDocumentConditionMet(ShipmentHeader, IndustryDocument.Condition) then begin
                    if not RequiredCodes.Contains(IndustryDocument."Document Code") then
                        RequiredCodes.Add(IndustryDocument."Document Code");
                    if ShipmentDocument.Get(ShipmentHeader."No.", IndustryDocument."Document Code") then begin
                        if IndustryDocument.Mandatory and not ShipmentDocument.Mandatory then begin
                            ShipmentDocument.Mandatory := true;
                            ShipmentDocument.Modify();
                        end;
                    end else begin
                        ShipmentDocument.Init();
                        ShipmentDocument."Shipment No." := ShipmentHeader."No.";
                        ShipmentDocument."Document Code" := IndustryDocument."Document Code";
                        ShipmentDocument.Description := IndustryDocument.Description;
                        ShipmentDocument.Mandatory := IndustryDocument.Mandatory;
                        ShipmentDocument."Auto-Generated" := true;
                        ShipmentDocument.Insert();
                    end;
                end;
            until IndustryDocument.Next() = 0;

        ShipmentDocument.Reset();
        ShipmentDocument.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentDocument.SetRange("Auto-Generated", true);
        ShipmentDocument.SetRange(Received, false);
        if ShipmentDocument.FindSet() then
            repeat
                if not RequiredCodes.Contains(ShipmentDocument."Document Code") then
                    ShipmentDocument.Delete();
            until ShipmentDocument.Next() = 0;
    end;

    procedure IsDocumentConditionMet(ShipmentHeader: Record "LMS Shipment Header"; Condition: Enum "LMS Document Condition") Result: Boolean
    var
        ShipmentLine: Record "LMS Shipment Line";
    begin
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        case Condition of
            Condition::Always:
                Result := true;
            Condition::"Hazardous Goods":
                begin
                    ShipmentLine.SetRange(Hazardous, true);
                    Result := not ShipmentLine.IsEmpty();
                end;
            Condition::"Temperature Controlled":
                begin
                    ShipmentLine.SetRange("Temperature Controlled", true);
                    Result := not ShipmentLine.IsEmpty();
                end;
            Condition::"Cross-Border":
                Result := ShipmentHeader.IsCrossBorder();
            Condition::"High Value":
                begin
                    ShipmentLine.SetRange("Handling Class", ShipmentLine."Handling Class"::"High Value");
                    Result := not ShipmentLine.IsEmpty();
                end;
            Condition::Oversized:
                begin
                    ShipmentLine.SetRange("Handling Class", ShipmentLine."Handling Class"::Oversized);
                    Result := not ShipmentLine.IsEmpty();
                end;
        end;
        OnAfterIsDocumentConditionMet(ShipmentHeader, Condition, Result);
    end;

    local procedure CheckLines(var ShipmentHeader: Record "LMS Shipment Header"; IndustryProfile: Record "LMS Industry Profile"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ShipmentLine: Record "LMS Shipment Line";
        GoodsType: Record "LMS Goods Type";
        ReqMinTemp: Decimal;
        ReqMaxTemp: Decimal;
        RemainingDays: Integer;
        CrossBorder: Boolean;
    begin
        ShipmentHeader."Contains Hazardous Goods" := false;
        ShipmentHeader."Temperature Controlled" := false;
        ShipmentHeader."Required Min. Temp. (C)" := 0;
        ShipmentHeader."Required Max. Temp. (C)" := 0;
        ReqMinTemp := -1000;
        ReqMaxTemp := 1000;
        CrossBorder := ShipmentHeader.IsCrossBorder();

        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if not ShipmentLine.FindSet() then begin
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, GenericRuleTxt, NoLinesErr);
            exit;
        end;

        repeat
            if ShipmentLine.Quantity <= 0 then
                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt, StrSubstNo(NoQuantityErr, ShipmentLine."Line No.", ShipmentLine.Description));
            if ShipmentLine."Goods Type Code" = '' then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt, StrSubstNo(NoGoodsTypeMsg, ShipmentLine."Line No.", ShipmentLine.Description));
            if ShipmentLine."Gross Weight (kg)" = 0 then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt, StrSubstNo(NoWeightMsg, ShipmentLine."Line No.", ShipmentLine.Description));

            if IndustryProfile."Requires Lot Tracking" and (ShipmentLine."Lot No." = '') then
                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", ProfileRuleTxt, StrSubstNo(LotRequiredErr, ShipmentLine."Line No.", ShipmentLine.Description, IndustryProfile.Code));
            if IndustryProfile."Requires Serial Tracking" and (ShipmentLine."Serial No." = '') then
                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", ProfileRuleTxt, StrSubstNo(SerialRequiredErr, ShipmentLine."Line No.", ShipmentLine.Description, IndustryProfile.Code));
            if CrossBorder and IndustryProfile."Requires Customs Data" and (ShipmentLine."Tariff No." = '') then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", ProfileRuleTxt, StrSubstNo(TariffMsg, ShipmentLine."Line No.", ShipmentLine.Description));

            if ShipmentLine.Hazardous then begin
                ShipmentHeader."Contains Hazardous Goods" := true;
                if ShipmentLine."UN Number" = '' then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt, StrSubstNo(UNNumberErr, ShipmentLine."Line No.", ShipmentLine.Description));
            end;

            if ShipmentLine."Temperature Controlled" then begin
                ShipmentHeader."Temperature Controlled" := true;
                if ShipmentLine."Min. Temperature (C)" > ReqMinTemp then
                    ReqMinTemp := ShipmentLine."Min. Temperature (C)";
                if ShipmentLine."Max. Temperature (C)" < ReqMaxTemp then
                    ReqMaxTemp := ShipmentLine."Max. Temperature (C)";
            end;

            if ShipmentLine."Expiration Date" <> 0D then
                if ShipmentLine."Expiration Date" < ShipmentHeader."Shipment Date" then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt, StrSubstNo(ExpiredErr, ShipmentLine."Line No.", ShipmentLine.Description, ShipmentLine."Expiration Date"))
                else
                    if GoodsType.Get(ShipmentLine."Goods Type Code") and (GoodsType."Min. Shelf Life (Days)" > 0) then begin
                        RemainingDays := ShipmentLine."Expiration Date" - ShipmentHeader."Shipment Date";
                        if RemainingDays < GoodsType."Min. Shelf Life (Days)" then
                            TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", GenericRuleTxt,
                                StrSubstNo(ShelfLifeErr, ShipmentLine."Line No.", ShipmentLine.Description, RemainingDays, GoodsType.Code, GoodsType."Min. Shelf Life (Days)"));
                    end;
        until ShipmentLine.Next() = 0;

        if ShipmentHeader."Temperature Controlled" then begin
            ShipmentHeader."Required Min. Temp. (C)" := ReqMinTemp;
            ShipmentHeader."Required Max. Temp. (C)" := ReqMaxTemp;
            if ReqMinTemp > ReqMaxTemp then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, GenericRuleTxt, StrSubstNo(TempConflictErr, ReqMinTemp, ReqMaxTemp));
        end else
            if IndustryProfile."Requires Temp. Control" then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, ProfileRuleTxt, StrSubstNo(TempRequiredByProfileMsg, IndustryProfile.Code));
    end;

    local procedure CheckVehicle(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        Vehicle: Record "LMS Vehicle";
        ShipmentLine: Record "LMS Shipment Line";
        GoodsType: Record "LMS Goods Type";
    begin
        if ShipmentHeader."Vehicle No." = '' then begin
            TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, VehicleRuleTxt, NoVehicleMsg);
            exit;
        end;
        if not Vehicle.Get(ShipmentHeader."Vehicle No.") then begin
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(VehicleNotFoundErr, ShipmentHeader."Vehicle No."));
            exit;
        end;

        case Vehicle.Status of
            Vehicle.Status::Maintenance, Vehicle.Status::Inactive:
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(VehicleUnavailableErr, Vehicle."No.", Vehicle.Status));
            Vehicle.Status::"On Trip":
                if not ShipmentHeader.IsInTransit() then
                    TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(VehicleOnTripMsg, Vehicle."No."));
        end;

        if (ShipmentHeader."Transport Mode" <> ShipmentHeader."Transport Mode"::Multimodal) and (Vehicle."Transport Mode" <> ShipmentHeader."Transport Mode") then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(ModeMismatchErr, Vehicle."No.", Vehicle."Transport Mode", ShipmentHeader."Transport Mode"));

        if (Vehicle."Insurance Expiry Date" <> 0D) and (Vehicle."Insurance Expiry Date" < ShipmentHeader."Shipment Date") then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(VehicleInsuranceErr, Vehicle."No.", Vehicle."Insurance Expiry Date"));

        if (Vehicle."Max. Weight (kg)" > 0) and (ShipmentHeader."Total Gross Weight (kg)" > Vehicle."Max. Weight (kg)") then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(OverweightErr, ShipmentHeader."Total Gross Weight (kg)", Vehicle."No.", Vehicle."Max. Weight (kg)"));
        if (Vehicle."Max. Volume (m3)" > 0) and (ShipmentHeader."Total Volume (m3)" > Vehicle."Max. Volume (m3)") then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(OvervolumeErr, ShipmentHeader."Total Volume (m3)", Vehicle."No.", Vehicle."Max. Volume (m3)"));
        if (Vehicle."Max. Pallets" > 0) and (ShipmentHeader."Total Pallets" > Vehicle."Max. Pallets") then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(OverPalletsErr, ShipmentHeader."Total Pallets", Vehicle."No.", Vehicle."Max. Pallets"));

        if ShipmentHeader."Temperature Controlled" then
            if not Vehicle."Temperature Controlled" then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(NotReeferErr, Vehicle."No."))
            else
                if (Vehicle."Min. Temperature (C)" > ShipmentHeader."Required Max. Temp. (C)") or
                   (Vehicle."Max. Temperature (C)" < ShipmentHeader."Required Min. Temp. (C)")
                then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt,
                        StrSubstNo(ReeferRangeErr, Vehicle."No.", Vehicle."Min. Temperature (C)", Vehicle."Max. Temperature (C)",
                            ShipmentHeader."Required Min. Temp. (C)", ShipmentHeader."Required Max. Temp. (C)"));

        if ShipmentHeader."Contains Hazardous Goods" and not Vehicle."Hazmat Certified" then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, VehicleRuleTxt, StrSubstNo(NotHazmatVehicleErr, Vehicle."No."));

        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter("Goods Type Code", '<>%1', '');
        if ShipmentLine.FindSet() then
            repeat
                if GoodsType.Get(ShipmentLine."Goods Type Code") then
                    if not GoodsType.IsVehicleTypeAllowed(Vehicle."Vehicle Type") then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", VehicleRuleTxt,
                            StrSubstNo(VehicleTypeNotAllowedErr, ShipmentLine."Line No.", ShipmentLine.Description, GoodsType.Code, Vehicle."Vehicle Type"));
            until ShipmentLine.Next() = 0;
    end;

    local procedure CheckDriver(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        LMSSetup: Record "LMS Setup";
        Driver: Record "LMS Driver";
    begin
        if ShipmentHeader."Driver No." = '' then begin
            if ShipmentHeader."Vehicle No." <> '' then
                TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, DriverRuleTxt, NoDriverMsg);
            exit;
        end;
        if not Driver.Get(ShipmentHeader."Driver No.") then begin
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, DriverRuleTxt, StrSubstNo(DriverNotFoundErr, ShipmentHeader."Driver No."));
            exit;
        end;

        if Driver.Status in [Driver.Status::Maintenance, Driver.Status::Inactive] then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, DriverRuleTxt, StrSubstNo(DriverUnavailableErr, Driver."No.", Driver.Status));

        if Driver."License Expiry Date" <> 0D then begin
            LMSSetup.GetRecordOnce();
            if Driver."License Expiry Date" < ShipmentHeader."Shipment Date" then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, DriverRuleTxt, StrSubstNo(LicenseExpiredErr, Driver."No.", Driver."License Expiry Date"))
            else
                if Driver."License Expiry Date" - ShipmentHeader."Shipment Date" <= LMSSetup."Expiry Warning Days" then
                    TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, DriverRuleTxt, StrSubstNo(LicenseExpiringMsg, Driver."No.", Driver."License Expiry Date"));
        end;

        if ShipmentHeader."Contains Hazardous Goods" then
            if (not Driver."Hazmat Certified") or
               ((Driver."Hazmat Cert. Expiry Date" <> 0D) and (Driver."Hazmat Cert. Expiry Date" < ShipmentHeader."Shipment Date"))
            then
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, DriverRuleTxt, StrSubstNo(DriverHazmatErr, Driver."No."));
    end;

    local procedure CheckRoute(ShipmentHeader: Record "LMS Shipment Header"; IndustryProfile: Record "LMS Industry Profile"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        Route: Record "LMS Route";
    begin
        if IndustryProfile."Max. Transit Hours" = 0 then
            exit;
        if not Route.Get(ShipmentHeader."Route Code") then
            exit;
        if Route."Est. Transit Hours" > IndustryProfile."Max. Transit Hours" then
            TempComplianceIssue.AddWarning(ShipmentHeader."No.", 0, ProfileRuleTxt,
                StrSubstNo(TransitTooLongMsg, Route.Code, Route."Est. Transit Hours", IndustryProfile."Max. Transit Hours", IndustryProfile.Code));
    end;

    local procedure CheckDocuments(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ShipmentDocument: Record "LMS Shipment Document";
    begin
        ShipmentDocument.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentDocument.SetRange(Mandatory, true);
        ShipmentDocument.SetRange(Received, false);
        if ShipmentDocument.FindSet() then
            repeat
                TempComplianceIssue.AddError(ShipmentHeader."No.", 0, DocumentRuleTxt, StrSubstNo(DocumentMissingErr, ShipmentDocument."Document Code", ShipmentDocument.Description));
            until ShipmentDocument.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckShipment(var ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckShipment(var ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsDocumentConditionMet(ShipmentHeader: Record "LMS Shipment Header"; Condition: Enum "LMS Document Condition"; var Result: Boolean)
    begin
    end;
}
