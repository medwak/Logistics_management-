/// <summary>
/// Read-only REST endpoint for customer portals, carriers and BI:
/// /api/medwak/logistics/v1.0/companies({id})/shipments
/// </summary>
page 50119 "LMS Shipments API"
{
    PageType = API;
    Caption = 'shipments', Locked = true;
    APIPublisher = 'medwak';
    APIGroup = 'logistics';
    APIVersion = 'v1.0';
    EntityName = 'shipment';
    EntitySetName = 'shipments';
    SourceTable = "LMS Shipment Header";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id', Locked = true;
                }
                field(number; Rec."No.")
                {
                    Caption = 'Number', Locked = true;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status', Locked = true;
                }
                field(customerNumber; Rec."Customer No.")
                {
                    Caption = 'Customer Number', Locked = true;
                }
                field(industryCode; Rec."Industry Code")
                {
                    Caption = 'Industry Code', Locked = true;
                }
                field(transportMode; Rec."Transport Mode")
                {
                    Caption = 'Transport Mode', Locked = true;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name', Locked = true;
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City', Locked = true;
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country', Locked = true;
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date', Locked = true;
                }
                field(plannedDeliveryDate; Rec."Planned Delivery Date")
                {
                    Caption = 'Planned Delivery Date', Locked = true;
                }
                field(actualDeliveryDateTime; Rec."Actual Delivery DateTime")
                {
                    Caption = 'Actual Delivery Date/Time', Locked = true;
                }
                field(lastKnownLocation; Rec."Last Known Location")
                {
                    Caption = 'Last Known Location', Locked = true;
                }
                field(carrierTrackingNumber; Rec."Tracking No.")
                {
                    Caption = 'Carrier Tracking Number', Locked = true;
                }
                field(totalCharge; Rec."Total Charge")
                {
                    Caption = 'Total Charge', Locked = true;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date/Time', Locked = true;
                }
            }
        }
    }
}
