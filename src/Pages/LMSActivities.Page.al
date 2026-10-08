page 50117 "LMS Activities"
{
    Caption = 'Logistics Activities';
    PageType = CardPart;
    SourceTable = "LMS Cue";
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(ShipmentCues)
            {
                Caption = 'Shipments';
                field("Open Shipments"; Rec."Open Shipments")
                {
                    DrillDownPageId = "LMS Shipments";
                    ToolTip = 'Specifies the number of shipments being prepared.';
                }
                field("Ready to Dispatch"; Rec."Ready to Dispatch")
                {
                    DrillDownPageId = "LMS Shipments";
                    ToolTip = 'Specifies the number of released or planned shipments waiting for pickup.';
                }
                field("In Transit"; Rec."In Transit")
                {
                    DrillDownPageId = "LMS Shipments";
                    ToolTip = 'Specifies the number of shipments on the way.';
                }
                field("Delivered Today"; Rec."Delivered Today")
                {
                    DrillDownPageId = "LMS Shipments";
                    ToolTip = 'Specifies the number of shipments delivered today.';
                }
            }
            cuegroup(AttentionCues)
            {
                Caption = 'Needs Attention';
                field(Exceptions; Rec.Exceptions)
                {
                    DrillDownPageId = "LMS Shipments";
                    StyleExpr = ExceptionsStyle;
                    ToolTip = 'Specifies the number of shipments with an exception.';
                }
                field("Late Shipments"; Rec."Late Shipments")
                {
                    DrillDownPageId = "LMS Shipments";
                    StyleExpr = LateStyle;
                    ToolTip = 'Specifies the number of undelivered shipments past their planned delivery date.';
                }
            }
            cuegroup(FleetCues)
            {
                Caption = 'Fleet';
                field("Vehicles Available"; Rec."Vehicles Available")
                {
                    DrillDownPageId = "LMS Vehicles";
                    ToolTip = 'Specifies the number of available vehicles.';
                }
                field("Vehicles on Trip"; Rec."Vehicles on Trip")
                {
                    DrillDownPageId = "LMS Vehicles";
                    ToolTip = 'Specifies the number of vehicles on a trip.';
                }
                field("Vehicles in Maintenance"; Rec."Vehicles in Maintenance")
                {
                    DrillDownPageId = "LMS Vehicles";
                    ToolTip = 'Specifies the number of vehicles in maintenance.';
                }
            }
        }
    }

    var
        ExceptionsStyle: Text;
        LateStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        Rec.SetRange("Date Filter", WorkDate());
        Rec.SetRange("Overdue Date Filter", CalcDate('<-10Y>', WorkDate()), WorkDate() - 1);
    end;

    trigger OnAfterGetRecord()
    begin
        ExceptionsStyle := 'Favorable';
        LateStyle := 'Favorable';
        Rec.CalcFields(Exceptions, "Late Shipments");
        if Rec.Exceptions > 0 then
            ExceptionsStyle := 'Unfavorable';
        if Rec."Late Shipments" > 0 then
            LateStyle := 'Unfavorable';
    end;
}
