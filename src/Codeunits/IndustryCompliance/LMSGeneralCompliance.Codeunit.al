/// <summary>
/// Default implementation: industries without extra rules (General, Retail, Textile, ...) rely on
/// the generic, data-driven checks of the industry profile and goods types only.
/// </summary>
codeunit 50120 "LMS General Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    begin
    end;
}
