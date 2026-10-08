page 50109 "LMS Freight Rates"
{
    Caption = 'Freight Rates';
    PageType = List;
    SourceTable = "LMS Freight Rate";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Transport Mode"; Rec."Transport Mode")
                {
                    ToolTip = 'Specifies the transport mode.';
                }
                field("Goods Type Code"; Rec."Goods Type Code")
                {
                    ToolTip = 'Specifies the goods type. Leave blank for all goods types.';
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ToolTip = 'Specifies the rate zone. Leave blank for all zones.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the date from which the rate applies.';
                }
                field("Minimum Weight (kg)"; Rec."Minimum Weight (kg)")
                {
                    ToolTip = 'Specifies the weight break from which the rate applies.';
                }
                field("Rate Basis"; Rec."Rate Basis")
                {
                    ToolTip = 'Specifies how the rate is applied.';
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the rate.';
                }
                field("Minimum Charge"; Rec."Minimum Charge")
                {
                    ToolTip = 'Specifies the minimum freight charge.';
                }
                field("Volumetric Factor (kg/m3)"; Rec."Volumetric Factor (kg/m3)")
                {
                    ToolTip = 'Specifies the kg per m3 for chargeable weight. Zero uses the factor from the logistics setup.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
            }
        }
    }
}
