codeunit 50112 "LMS Per Volume Rate Calc." implements "LMS IFreight Rate Calculator"
{
    Access = Public;

    procedure CalculateCharge(FreightRate: Record "LMS Freight Rate"; ShipmentHeader: Record "LMS Shipment Header"): Decimal
    begin
        exit(FreightRate.Rate * ShipmentHeader."Total Volume (m3)");
    end;
}
