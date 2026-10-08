page 50108 "LMS Routes"
{
    Caption = 'Routes';
    PageType = List;
    SourceTable = "LMS Route";
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
                    ToolTip = 'Specifies the route code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
                field("Origin Location Code"; Rec."Origin Location Code")
                {
                    ToolTip = 'Specifies the location where the route starts.';
                }
                field(Origin; Rec.Origin)
                {
                    ToolTip = 'Specifies the origin.';
                }
                field(Destination; Rec.Destination)
                {
                    ToolTip = 'Specifies the destination.';
                }
                field("Destination Country Code"; Rec."Destination Country Code")
                {
                    ToolTip = 'Specifies the destination country/region.';
                }
                field("Transport Mode"; Rec."Transport Mode")
                {
                    ToolTip = 'Specifies the transport mode.';
                }
                field("Distance (km)"; Rec."Distance (km)")
                {
                    ToolTip = 'Specifies the distance.';
                }
                field("Est. Transit Hours"; Rec."Est. Transit Hours")
                {
                    ToolTip = 'Specifies the estimated transit time.';
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ToolTip = 'Specifies the rate zone used to find freight rates.';
                }
            }
        }
    }
}
