/// <summary>
/// Charges on the greater of actual weight and volumetric weight (volume x volumetric factor),
/// the standard approach for air, courier and LTL road freight.
/// </summary>
codeunit 50115 "LMS Chargeable Wt. Rate Calc." implements "LMS IFreight Rate Calculator"
{
    Access = Public;

    procedure CalculateCharge(FreightRate: Record "LMS Freight Rate"; ShipmentHeader: Record "LMS Shipment Header"): Decimal
    begin
        exit(FreightRate.Rate * GetChargeableWeight(FreightRate, ShipmentHeader));
    end;

    procedure GetChargeableWeight(FreightRate: Record "LMS Freight Rate"; ShipmentHeader: Record "LMS Shipment Header"): Decimal
    var
        LMSSetup: Record "LMS Setup";
        VolumetricFactor: Decimal;
        VolumetricWeight: Decimal;
    begin
        VolumetricFactor := FreightRate."Volumetric Factor (kg/m3)";
        if VolumetricFactor = 0 then begin
            LMSSetup.GetRecordOnce();
            VolumetricFactor := LMSSetup."Volumetric Factor (kg/m3)";
        end;
        VolumetricWeight := ShipmentHeader."Total Volume (m3)" * VolumetricFactor;
        if VolumetricWeight > ShipmentHeader."Total Gross Weight (kg)" then
            exit(VolumetricWeight);
        exit(ShipmentHeader."Total Gross Weight (kg)");
    end;
}
