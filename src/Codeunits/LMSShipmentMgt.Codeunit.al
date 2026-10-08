/// <summary>
/// Shipment lifecycle: release (with compliance gate), planning, status transitions with
/// tracking, proof of delivery, resource status, and creation from sales orders.
/// </summary>
codeunit 50102 "LMS Shipment Mgt."
{
    var
        LMSSetup: Record "LMS Setup";
        ComplianceMgt: Codeunit "LMS Compliance Mgt.";
        TrackingMgt: Codeunit "LMS Tracking Mgt.";
        FreightCalcMgt: Codeunit "LMS Freight Calc. Mgt.";
        ComplianceErrorsErr: Label 'Shipment %1 cannot be released because it has compliance errors.', Comment = '%1 = shipment no.';
        ComplianceWarningsBlockErr: Label 'Shipment %1 cannot be released because it has compliance warnings and the logistics setup blocks release on warnings.', Comment = '%1 = shipment no.';
        ComplianceWarningsQst: Label 'Shipment %1 has compliance warnings. Do you want to release it anyway?', Comment = '%1 = shipment no.';
        NoIssuesMsg: Label 'Shipment %1 passed all compliance checks.', Comment = '%1 = shipment no.';
        ReleasedTxt: Label 'Shipment released.';
        ReopenedTxt: Label 'Shipment reopened.';
        PlannedTxt: Label 'Vehicle %1 and driver %2 assigned.', Comment = '%1 = vehicle, %2 = driver';
        CannotReopenErr: Label 'Shipment %1 cannot be reopened because it has status %2.', Comment = '%1 = shipment no., %2 = status';
        InvalidTransitionErr: Label 'The status of shipment %1 cannot change from %2 to %3.', Comment = '%1 = no., %2 = from, %3 = to';
        PODRequiredErr: Label 'Industry profile %1 requires proof of delivery. Enter who received the goods.', Comment = '%1 = profile';
        VehicleRequiredErr: Label 'A vehicle or a carrier (shipping agent) must be assigned before shipment %1 can be picked up.', Comment = '%1 = shipment no.';
        ExistingShipmentQst: Label 'Logistics shipment %1 already exists for %2 %3. Do you want to create another one?', Comment = '%1 = shipment no., %2 = source type, %3 = source no.';
        NoLinesToShipErr: Label 'There is nothing to ship on %1 %2.', Comment = '%1 = document type, %2 = no.';

    procedure Release(var ShipmentHeader: Record "LMS Shipment Header")
    var
        TempComplianceIssue: Record "LMS Compliance Issue";
    begin
        if ShipmentHeader.Status = ShipmentHeader.Status::Released then
            exit;
        ShipmentHeader.TestField(Status, ShipmentHeader.Status::Open);
        OnBeforeRelease(ShipmentHeader);
        LMSSetup.GetRecordOnce();

        ComplianceMgt.RefreshRequiredDocuments(ShipmentHeader);
        if not ComplianceMgt.CheckShipment(ShipmentHeader, TempComplianceIssue) then begin
            ShowIssues(TempComplianceIssue);
            Error(ComplianceErrorsErr, ShipmentHeader."No.");
        end;
        if not TempComplianceIssue.IsEmpty() then begin
            if LMSSetup."Block Release on Warnings" then begin
                ShowIssues(TempComplianceIssue);
                Error(ComplianceWarningsBlockErr, ShipmentHeader."No.");
            end;
            if GuiAllowed() then
                if not Confirm(ComplianceWarningsQst, false, ShipmentHeader."No.") then begin
                    ShowIssues(TempComplianceIssue);
                    Error('');
                end;
        end;

        // CheckShipment derived the temperature / hazmat flags on the header
        ShipmentHeader.Modify(true);
        if LMSSetup."Auto-Calc. Charges on Release" then
            FreightCalcMgt.CalculateCharges(ShipmentHeader);

        ShipmentHeader.Status := ShipmentHeader.Status::Released;
        ShipmentHeader.Modify(true);
        TrackingMgt.LogEvent(ShipmentHeader, ShipmentHeader.Status, '', ReleasedTxt);
        OnAfterRelease(ShipmentHeader);
    end;

    procedure Reopen(var ShipmentHeader: Record "LMS Shipment Header")
    begin
        if ShipmentHeader.Status = ShipmentHeader.Status::Open then
            exit;
        if not (ShipmentHeader.Status in [ShipmentHeader.Status::Released, ShipmentHeader.Status::Planned]) then
            Error(CannotReopenErr, ShipmentHeader."No.", ShipmentHeader.Status);
        ShipmentHeader.Status := ShipmentHeader.Status::Open;
        ShipmentHeader.Modify(true);
        TrackingMgt.LogEvent(ShipmentHeader, ShipmentHeader.Status, '', ReopenedTxt);
    end;

    procedure CheckCompliance(var ShipmentHeader: Record "LMS Shipment Header")
    var
        TempComplianceIssue: Record "LMS Compliance Issue";
    begin
        if ShipmentHeader.Status = ShipmentHeader.Status::Open then
            ComplianceMgt.RefreshRequiredDocuments(ShipmentHeader);
        ComplianceMgt.CheckShipment(ShipmentHeader, TempComplianceIssue);
        if TempComplianceIssue.IsEmpty() then
            Message(NoIssuesMsg, ShipmentHeader."No.")
        else
            ShowIssues(TempComplianceIssue);
    end;

    /// <summary>Assigns the transport resources and re-validates compliance against them.</summary>
    procedure Plan(var ShipmentHeader: Record "LMS Shipment Header")
    var
        TempComplianceIssue: Record "LMS Compliance Issue";
    begin
        if ShipmentHeader.Status = ShipmentHeader.Status::Open then
            Release(ShipmentHeader);
        ShipmentHeader.TestField(Status, ShipmentHeader.Status::Released);
        ShipmentHeader.TestField("Vehicle No.");
        ShipmentHeader.TestField("Driver No.");

        if not ComplianceMgt.CheckShipment(ShipmentHeader, TempComplianceIssue) then begin
            ShowIssues(TempComplianceIssue);
            Error(ComplianceErrorsErr, ShipmentHeader."No.");
        end;

        SetStatus(ShipmentHeader, ShipmentHeader.Status::Planned, '', StrSubstNo(PlannedTxt, ShipmentHeader."Vehicle No.", ShipmentHeader."Driver No."), '');
    end;

    procedure SetStatus(var ShipmentHeader: Record "LMS Shipment Header"; NewStatus: Enum "LMS Shipment Status"; EventLocation: Text[100]; EventDescription: Text[250]; ReceivedBy: Text[100])
    var
        IndustryProfile: Record "LMS Industry Profile";
    begin
        if not IsTransitionAllowed(ShipmentHeader.Status, NewStatus) then
            Error(InvalidTransitionErr, ShipmentHeader."No.", ShipmentHeader.Status, NewStatus);

        case NewStatus of
            NewStatus::Planned:
                begin
                    ShipmentHeader.TestField("Vehicle No.");
                    ShipmentHeader.TestField("Driver No.");
                end;
            NewStatus::"Picked Up":
                begin
                    if (ShipmentHeader."Vehicle No." = '') and (ShipmentHeader."Shipping Agent Code" = '') then
                        Error(VehicleRequiredErr, ShipmentHeader."No.");
                    ShipmentHeader."Actual Pickup DateTime" := CurrentDateTime();
                    SetResourceStatus(ShipmentHeader, "LMS Resource Status"::"On Trip");
                end;
            NewStatus::Delivered:
                begin
                    if ReceivedBy <> '' then
                        ShipmentHeader."POD Received By" := ReceivedBy;
                    if IndustryProfile.Get(ShipmentHeader."Industry Code") then
                        if IndustryProfile."Requires Proof of Delivery" and (ShipmentHeader."POD Received By" = '') then
                            Error(PODRequiredErr, IndustryProfile.Code);
                    ShipmentHeader."Actual Delivery DateTime" := CurrentDateTime();
                    ShipmentHeader."Actual Delivery Date" := Today();
                    SetResourceStatus(ShipmentHeader, "LMS Resource Status"::Available);
                end;
            NewStatus::Cancelled:
                if ShipmentHeader.IsInTransit() then
                    SetResourceStatus(ShipmentHeader, "LMS Resource Status"::Available);
        end;

        OnBeforeSetStatus(ShipmentHeader, NewStatus);
        ShipmentHeader.Status := NewStatus;
        ShipmentHeader.Modify(true);
        TrackingMgt.LogEvent(ShipmentHeader, NewStatus, EventLocation, EventDescription);
        OnAfterSetStatus(ShipmentHeader);
    end;

    procedure IsTransitionAllowed(FromStatus: Enum "LMS Shipment Status"; ToStatus: Enum "LMS Shipment Status") Allowed: Boolean
    begin
        case FromStatus of
            // Open <-> Released only through Release() / Reopen(), so the compliance gate cannot be bypassed
            FromStatus::Open:
                Allowed := ToStatus = ToStatus::Cancelled;
            FromStatus::Released:
                Allowed := ToStatus in [ToStatus::Planned, ToStatus::"Picked Up", ToStatus::Cancelled];
            FromStatus::Planned:
                Allowed := ToStatus in [ToStatus::"Picked Up", ToStatus::Cancelled];
            FromStatus::"Picked Up":
                Allowed := ToStatus in [ToStatus::"In Transit", ToStatus::"At Hub", ToStatus::"Out for Delivery", ToStatus::Delivered, ToStatus::Exception];
            FromStatus::"In Transit":
                Allowed := ToStatus in [ToStatus::"In Transit", ToStatus::"At Hub", ToStatus::"Out for Delivery", ToStatus::Delivered, ToStatus::Exception];
            FromStatus::"At Hub":
                Allowed := ToStatus in [ToStatus::"In Transit", ToStatus::"Out for Delivery", ToStatus::Exception];
            FromStatus::"Out for Delivery":
                Allowed := ToStatus in [ToStatus::Delivered, ToStatus::"At Hub", ToStatus::Exception];
            FromStatus::Exception:
                Allowed := ToStatus in [ToStatus::"In Transit", ToStatus::"At Hub", ToStatus::"Out for Delivery", ToStatus::Delivered, ToStatus::Cancelled];
            else
                Allowed := false;
        end;
        OnAfterIsTransitionAllowed(FromStatus, ToStatus, Allowed);
    end;

    procedure CreateFromSalesOrder(SalesHeader: Record "Sales Header"): Code[20]
    var
        ShipmentHeader: Record "LMS Shipment Header";
        ShipmentLine: Record "LMS Shipment Line";
        ExistingShipment: Record "LMS Shipment Header";
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order);

        ExistingShipment.SetRange("Source Document Type", ExistingShipment."Source Document Type"::"Sales Order");
        ExistingShipment.SetRange("Source Document No.", SalesHeader."No.");
        ExistingShipment.SetFilter(Status, '<>%1', ExistingShipment.Status::Cancelled);
        if ExistingShipment.FindFirst() then
            if not Confirm(ExistingShipmentQst, false, ExistingShipment."No.", SalesHeader."Document Type", SalesHeader."No.") then
                exit(ExistingShipment."No.");

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        if SalesLine.IsEmpty() then
            Error(NoLinesToShipErr, SalesHeader."Document Type", SalesHeader."No.");

        ShipmentHeader.Init();
        if SalesHeader."Shipment Date" <> 0D then
            ShipmentHeader."Shipment Date" := SalesHeader."Shipment Date";
        ShipmentHeader.Insert(true);
        ShipmentHeader.Validate("Customer No.", SalesHeader."Sell-to Customer No.");
        ShipmentHeader."Ship-to Name" := SalesHeader."Ship-to Name";
        ShipmentHeader."Ship-to Address" := SalesHeader."Ship-to Address";
        ShipmentHeader."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
        ShipmentHeader."Ship-to City" := SalesHeader."Ship-to City";
        ShipmentHeader."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
        ShipmentHeader."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";
        ShipmentHeader."Ship-to Contact" := SalesHeader."Ship-to Contact";
        if SalesHeader."Location Code" <> '' then
            ShipmentHeader."Ship-from Location Code" := SalesHeader."Location Code";
        if SalesHeader."Shipping Agent Code" <> '' then
            ShipmentHeader."Shipping Agent Code" := SalesHeader."Shipping Agent Code";
        ShipmentHeader."Source Document Type" := ShipmentHeader."Source Document Type"::"Sales Order";
        ShipmentHeader."Source Document No." := SalesHeader."No.";
        ShipmentHeader."External Reference" := SalesHeader."External Document No.";
        OnCreateFromSalesOrderOnBeforeModifyHeader(ShipmentHeader, SalesHeader);
        ShipmentHeader.Modify(true);

        SalesLine.FindSet();
        repeat
            LineNo += 10000;
            ShipmentLine.Init();
            ShipmentLine."Shipment No." := ShipmentHeader."No.";
            ShipmentLine."Line No." := LineNo;
            ShipmentLine.Validate(Type, ShipmentLine.Type::Item);
            ShipmentLine.Validate("No.", SalesLine."No.");
            if SalesLine."Unit of Measure Code" <> '' then
                ShipmentLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
            ShipmentLine.Description := SalesLine.Description;
            ShipmentLine.Validate("Declared Unit Value", SalesLine."Unit Price");
            ShipmentLine.Validate(Quantity, SalesLine."Outstanding Quantity");
            OnCreateFromSalesOrderOnBeforeInsertLine(ShipmentLine, SalesLine);
            ShipmentLine.Insert(true);
        until SalesLine.Next() = 0;

        ComplianceMgt.RefreshRequiredDocuments(ShipmentHeader);
        exit(ShipmentHeader."No.");
    end;

    procedure ShowIssues(var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ComplianceIssues: Page "LMS Compliance Issues";
    begin
        if not GuiAllowed() then
            exit;
        ComplianceIssues.SetIssues(TempComplianceIssue);
        ComplianceIssues.RunModal();
    end;

    local procedure SetResourceStatus(ShipmentHeader: Record "LMS Shipment Header"; NewStatus: Enum "LMS Resource Status")
    var
        Vehicle: Record "LMS Vehicle";
        Driver: Record "LMS Driver";
    begin
        if Vehicle.Get(ShipmentHeader."Vehicle No.") then
            if Vehicle.Status in [Vehicle.Status::Available, Vehicle.Status::"On Trip"] then begin
                Vehicle.Status := NewStatus;
                Vehicle.Modify(true);
            end;
        if Driver.Get(ShipmentHeader."Driver No.") then
            if Driver.Status in [Driver.Status::Available, Driver.Status::"On Trip"] then begin
                Driver.Status := NewStatus;
                Driver.Modify(true);
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRelease(var ShipmentHeader: Record "LMS Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRelease(var ShipmentHeader: Record "LMS Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetStatus(var ShipmentHeader: Record "LMS Shipment Header"; NewStatus: Enum "LMS Shipment Status")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetStatus(var ShipmentHeader: Record "LMS Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsTransitionAllowed(FromStatus: Enum "LMS Shipment Status"; ToStatus: Enum "LMS Shipment Status"; var Allowed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateFromSalesOrderOnBeforeModifyHeader(var ShipmentHeader: Record "LMS Shipment Header"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateFromSalesOrderOnBeforeInsertLine(var ShipmentLine: Record "LMS Shipment Line"; SalesLine: Record "Sales Line")
    begin
    end;
}
