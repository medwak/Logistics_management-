/// <summary>
/// Construction and mining: oversized / heavy-lift and bulk cargo must travel on suitable equipment.
/// </summary>
codeunit 50125 "LMS Heavy Cargo Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    var
        RuleTxt: Label 'Heavy Cargo', Locked = true;
        OversizedVehicleErr: Label 'Line %1 (%2): oversized cargo requires a flatbed/low-loader, rail wagon or vessel, not a %3.', Comment = '%1 = line no., %2 = description, %3 = vehicle type';
        BulkDryVehicleErr: Label 'Line %1 (%2): bulk dry cargo requires a tipper, rail wagon or vessel, not a %3.', Comment = '%1 = line no., %2 = description, %3 = vehicle type';
        BulkLiquidVehicleErr: Label 'Line %1 (%2): bulk liquid cargo requires a tanker, rail wagon or vessel, not a %3.', Comment = '%1 = line no., %2 = description, %3 = vehicle type';
        NoStackMsg: Label 'Line %1 (%2): goods are not stackable; verify that the floor space of the vehicle is sufficient.', Comment = '%1 = line no., %2 = description';

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ShipmentLine: Record "LMS Shipment Line";
        GoodsType: Record "LMS Goods Type";
        Vehicle: Record "LMS Vehicle";
        HasVehicle: Boolean;
    begin
        HasVehicle := Vehicle.Get(ShipmentHeader."Vehicle No.");
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if ShipmentLine.FindSet() then
            repeat
                if HasVehicle then
                    case ShipmentLine."Handling Class" of
                        ShipmentLine."Handling Class"::Oversized:
                            if not (Vehicle."Vehicle Type" in [Vehicle."Vehicle Type"::Flatbed, Vehicle."Vehicle Type"::"Rail Wagon", Vehicle."Vehicle Type"::Vessel]) then
                                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(OversizedVehicleErr, ShipmentLine."Line No.", ShipmentLine.Description, Vehicle."Vehicle Type"));
                        ShipmentLine."Handling Class"::"Bulk Dry":
                            if not (Vehicle."Vehicle Type" in [Vehicle."Vehicle Type"::Tipper, Vehicle."Vehicle Type"::"Rail Wagon", Vehicle."Vehicle Type"::Vessel]) then
                                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(BulkDryVehicleErr, ShipmentLine."Line No.", ShipmentLine.Description, Vehicle."Vehicle Type"));
                        ShipmentLine."Handling Class"::"Bulk Liquid":
                            if not (Vehicle."Vehicle Type" in [Vehicle."Vehicle Type"::Tanker, Vehicle."Vehicle Type"::"Rail Wagon", Vehicle."Vehicle Type"::Vessel]) then
                                TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(BulkLiquidVehicleErr, ShipmentLine."Line No.", ShipmentLine.Description, Vehicle."Vehicle Type"));
                    end;
                if GoodsType.Get(ShipmentLine."Goods Type Code") then
                    if not GoodsType.Stackable then
                        TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(NoStackMsg, ShipmentLine."Line No.", ShipmentLine.Description));
            until ShipmentLine.Next() = 0;
    end;
}
