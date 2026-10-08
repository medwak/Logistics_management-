/// <summary>
/// Calculates the base freight amount for a shipment from a freight rate.
/// The shipment header passed in has its total FlowFields calculated.
/// </summary>
interface "LMS IFreight Rate Calculator"
{
    procedure CalculateCharge(FreightRate: Record "LMS Freight Rate"; ShipmentHeader: Record "LMS Shipment Header"): Decimal;
}
