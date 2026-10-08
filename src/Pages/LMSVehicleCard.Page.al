page 50106 "LMS Vehicle Card"
{
    Caption = 'Vehicle Card';
    PageType = Card;
    SourceTable = "LMS Vehicle";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the vehicle number.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies the vehicle type.';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ToolTip = 'Specifies the registration / plate number.';
                }
                field("Transport Mode"; Rec."Transport Mode")
                {
                    ToolTip = 'Specifies the transport mode.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the availability of the vehicle.';
                }
                field("Owned By"; Rec."Owned By")
                {
                    ToolTip = 'Specifies whether the vehicle is owned by the company or by a subcontractor.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Specifies the subcontracted carrier that operates the vehicle.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the home depot of the vehicle.';
                }
                field("Default Driver No."; Rec."Default Driver No.")
                {
                    ToolTip = 'Specifies the default driver.';
                }
            }
            group(Capacity)
            {
                Caption = 'Capacity';
                field("Max. Weight (kg)"; Rec."Max. Weight (kg)")
                {
                    ToolTip = 'Specifies the maximum payload.';
                }
                field("Max. Volume (m3)"; Rec."Max. Volume (m3)")
                {
                    ToolTip = 'Specifies the maximum load volume.';
                }
                field("Max. Pallets"; Rec."Max. Pallets")
                {
                    ToolTip = 'Specifies the maximum number of pallets.';
                }
            }
            group(Capabilities)
            {
                Caption = 'Special Capabilities';
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the vehicle is refrigerated / temperature controlled.';
                }
                field("Min. Temperature (C)"; Rec."Min. Temperature (C)")
                {
                    ToolTip = 'Specifies the lowest temperature the vehicle can hold.';
                }
                field("Max. Temperature (C)"; Rec."Max. Temperature (C)")
                {
                    ToolTip = 'Specifies the highest temperature the vehicle can hold.';
                }
                field("Hazmat Certified"; Rec."Hazmat Certified")
                {
                    ToolTip = 'Specifies whether the vehicle is certified to carry dangerous goods.';
                }
            }
            group(Costs)
            {
                Caption = 'Costs & Maintenance';
                field("Cost per Km"; Rec."Cost per Km")
                {
                    ToolTip = 'Specifies the operating cost per kilometer.';
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ToolTip = 'Specifies when the vehicle is due for service.';
                }
                field("Insurance Expiry Date"; Rec."Insurance Expiry Date")
                {
                    ToolTip = 'Specifies when the vehicle insurance expires.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Shipments)
            {
                Caption = 'Shipments';
                Image = Shipment;
                RunObject = page "LMS Shipments";
                RunPageLink = "Vehicle No." = field("No.");
                ToolTip = 'View the shipments assigned to this vehicle.';
            }
        }
    }
}
