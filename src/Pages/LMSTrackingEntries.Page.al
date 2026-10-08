page 50114 "LMS Tracking Entries"
{
    Caption = 'Shipment Tracking';
    PageType = List;
    SourceTable = "LMS Tracking Entry";
    SourceTableView = sorting("Shipment No.", "Event DateTime") order(descending);
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Shipment No."; Rec."Shipment No.")
                {
                    ToolTip = 'Specifies the shipment.';
                }
                field("Event DateTime"; Rec."Event DateTime")
                {
                    ToolTip = 'Specifies when the event happened.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the shipment status after the event.';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies where the event happened.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the event.';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the vehicle.';
                }
                field("Temperature (C)"; Rec."Temperature (C)")
                {
                    ToolTip = 'Specifies the temperature recorded at the event.';
                }
                field(Latitude; Rec.Latitude)
                {
                    ToolTip = 'Specifies the GPS latitude.';
                }
                field(Longitude; Rec.Longitude)
                {
                    ToolTip = 'Specifies the GPS longitude.';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies who recorded the event.';
                }
            }
        }
    }
}
