page 50103 "LMS Goods Types"
{
    Caption = 'Goods Types';
    PageType = List;
    SourceTable = "LMS Goods Type";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the goods type code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
                field("Handling Class"; Rec."Handling Class")
                {
                    ToolTip = 'Specifies how the goods must be handled.';
                }
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the goods must be kept within a temperature range.';
                }
                field("Min. Temperature (C)"; Rec."Min. Temperature (C)")
                {
                    ToolTip = 'Specifies the minimum temperature in degrees Celsius.';
                }
                field("Max. Temperature (C)"; Rec."Max. Temperature (C)")
                {
                    ToolTip = 'Specifies the maximum temperature in degrees Celsius.';
                }
                field(Hazardous; Rec.Hazardous)
                {
                    ToolTip = 'Specifies whether the goods are dangerous goods.';
                }
                field("UN Number"; Rec."UN Number")
                {
                    ToolTip = 'Specifies the UN number of the dangerous goods.';
                }
                field("Hazard Class"; Rec."Hazard Class")
                {
                    ToolTip = 'Specifies the hazard class, for example 3 or 5.1.';
                }
                field("Packing Group"; Rec."Packing Group")
                {
                    ToolTip = 'Specifies the packing group (I, II or III).';
                }
                field(Stackable; Rec.Stackable)
                {
                    ToolTip = 'Specifies whether the goods can be stacked.';
                }
                field("Min. Shelf Life (Days)"; Rec."Min. Shelf Life (Days)")
                {
                    ToolTip = 'Specifies the minimum remaining shelf life required at shipment.';
                }
                field("Handling Surcharge %"; Rec."Handling Surcharge %")
                {
                    ToolTip = 'Specifies the surcharge on the freight charge for special handling.';
                }
                field("Insurance Rate %"; Rec."Insurance Rate %")
                {
                    ToolTip = 'Specifies the insurance premium as a percentage of the declared value.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(AllowedVehicles)
            {
                Caption = 'Allowed Vehicle Types';
                Image = Line;
                RunObject = page "LMS Goods Type Vehicles";
                RunPageLink = "Goods Type Code" = field("Code");
                ToolTip = 'Restrict the vehicle types that may carry this goods type. No entries means all vehicle types are allowed.';
            }
        }
        area(Promoted)
        {
            actionref(AllowedVehicles_Promoted; AllowedVehicles)
            {
            }
        }
    }
}
