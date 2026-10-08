page 50105 "LMS Vehicles"
{
    Caption = 'Vehicles';
    PageType = List;
    SourceTable = "LMS Vehicle";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "LMS Vehicle Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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
                field("Max. Weight (kg)"; Rec."Max. Weight (kg)")
                {
                    ToolTip = 'Specifies the maximum payload.';
                }
                field("Max. Volume (m3)"; Rec."Max. Volume (m3)")
                {
                    ToolTip = 'Specifies the maximum load volume.';
                }
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the vehicle is refrigerated / temperature controlled.';
                }
                field("Hazmat Certified"; Rec."Hazmat Certified")
                {
                    ToolTip = 'Specifies whether the vehicle is certified to carry dangerous goods.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the availability of the vehicle.';
                }
                field("Default Driver No."; Rec."Default Driver No.")
                {
                    ToolTip = 'Specifies the default driver.';
                }
            }
        }
    }
}
