/// <summary>
/// Food safety / agriculture rules: no dangerous goods with food, expiry on perishables,
/// shelf life must outlast transit, and live animals travel in a suitable vehicle.
/// </summary>
codeunit 50122 "LMS Food Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    var
        RuleTxt: Label 'Food Safety', Locked = true;
        HazardWithFoodErr: Label 'Hazardous goods must not be transported together with food or agricultural products.';
        ExpiryErr: Label 'Line %1 (%2): perishable goods require an expiration date.', Comment = '%1 = line no., %2 = description';
        ShelfLifeErr: Label 'Line %1 (%2): goods expire on %3, before the estimated arrival on %4.', Comment = '%1 = line no., %2 = description, %3 = expiry date, %4 = arrival date';
        LiveAnimalVehicleErr: Label 'Line %1 (%2): live animals must be carried by a livestock carrier.', Comment = '%1 = line no., %2 = description';

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ShipmentLine: Record "LMS Shipment Line";
        Vehicle: Record "LMS Vehicle";
        ArrivalDate: Date;
        HasVehicle: Boolean;
    begin
        if ShipmentHeader."Contains Hazardous Goods" then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, RuleTxt, HazardWithFoodErr);

        ArrivalDate := GetEstimatedArrival(ShipmentHeader);
        HasVehicle := Vehicle.Get(ShipmentHeader."Vehicle No.");

        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if ShipmentLine.FindSet() then
            repeat
                if ShipmentLine."Handling Class" in [ShipmentLine."Handling Class"::Perishable, ShipmentLine."Handling Class"::Frozen] then
                    if ShipmentLine."Expiration Date" = 0D then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(ExpiryErr, ShipmentLine."Line No.", ShipmentLine.Description));

                if (ShipmentLine."Expiration Date" <> 0D) and (ArrivalDate <> 0D) and (ShipmentLine."Expiration Date" < ArrivalDate) then
                    TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt,
                        StrSubstNo(ShelfLifeErr, ShipmentLine."Line No.", ShipmentLine.Description, ShipmentLine."Expiration Date", ArrivalDate));

                if (ShipmentLine."Handling Class" = ShipmentLine."Handling Class"::"Live Animals") and HasVehicle then
                    if Vehicle."Vehicle Type" <> Vehicle."Vehicle Type"::"Livestock Carrier" then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(LiveAnimalVehicleErr, ShipmentLine."Line No.", ShipmentLine.Description));
            until ShipmentLine.Next() = 0;
    end;

    local procedure GetEstimatedArrival(ShipmentHeader: Record "LMS Shipment Header"): Date
    var
        Route: Record "LMS Route";
        TransitDays: Integer;
    begin
        if ShipmentHeader."Planned Delivery Date" <> 0D then
            exit(ShipmentHeader."Planned Delivery Date");
        if not Route.Get(ShipmentHeader."Route Code") then
            exit(ShipmentHeader."Shipment Date");
        TransitDays := Round(Route."Est. Transit Hours" / 24, 1, '>');
        exit(ShipmentHeader."Shipment Date" + TransitDays);
    end;
}
