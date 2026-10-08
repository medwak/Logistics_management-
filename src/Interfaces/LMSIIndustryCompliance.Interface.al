/// <summary>
/// Industry-specific compliance rules applied on top of the generic, data-driven checks.
/// Implementations add entries to the temporary issue buffer; they must not raise errors.
/// </summary>
interface "LMS IIndustry Compliance"
{
    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue");
}
