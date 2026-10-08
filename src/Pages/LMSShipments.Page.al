page 50110 "LMS Shipments"
{
    Caption = 'Logistics Shipments';
    PageType = List;
    SourceTable = "LMS Shipment Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "LMS Shipment Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the shipment number.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the shipment.';
                    StyleExpr = StatusStyle;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the customer.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the customer name.';
                }
                field("Industry Code"; Rec."Industry Code")
                {
                    ToolTip = 'Specifies the industry profile.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the destination city.';
                }
                field("Transport Mode"; Rec."Transport Mode")
                {
                    ToolTip = 'Specifies the transport mode.';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the vehicle.';
                }
                field("Driver No."; Rec."Driver No.")
                {
                    ToolTip = 'Specifies the driver.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the shipment date.';
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ToolTip = 'Specifies the planned delivery date.';
                }
                field("Last Known Location"; Rec."Last Known Location")
                {
                    ToolTip = 'Specifies the last reported location.';
                }
                field("Contains Hazardous Goods"; Rec."Contains Hazardous Goods")
                {
                    ToolTip = 'Specifies whether the shipment contains dangerous goods.';
                }
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the shipment is temperature controlled.';
                }
                field("Total Charge"; Rec."Total Charge")
                {
                    ToolTip = 'Specifies the total logistics charge.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(TrackingEntries)
            {
                Caption = 'Tracking';
                Image = Navigate;
                RunObject = page "LMS Tracking Entries";
                RunPageLink = "Shipment No." = field("No.");
                ToolTip = 'View the tracking history of the shipment.';
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        StatusStyle := Rec.GetStatusStyle();
    end;
}
