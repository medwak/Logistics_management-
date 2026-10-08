codeunit 50105 "LMS Tracking Mgt."
{
    procedure LogEvent(var ShipmentHeader: Record "LMS Shipment Header"; NewStatus: Enum "LMS Shipment Status"; EventLocation: Text[100]; EventDescription: Text[250])
    begin
        LogEventDetailed(ShipmentHeader, NewStatus, EventLocation, EventDescription, 0, 0, 0);
    end;

    procedure LogEventDetailed(var ShipmentHeader: Record "LMS Shipment Header"; NewStatus: Enum "LMS Shipment Status"; EventLocation: Text[100]; EventDescription: Text[250]; NewLatitude: Decimal; NewLongitude: Decimal; RecordedTemperature: Decimal)
    var
        TrackingEntry: Record "LMS Tracking Entry";
    begin
        TrackingEntry.Init();
        TrackingEntry."Shipment No." := ShipmentHeader."No.";
        TrackingEntry."Event DateTime" := CurrentDateTime();
        TrackingEntry.Status := NewStatus;
        TrackingEntry.Location := EventLocation;
        TrackingEntry.Description := EventDescription;
        TrackingEntry.Latitude := NewLatitude;
        TrackingEntry.Longitude := NewLongitude;
        TrackingEntry."Temperature (C)" := RecordedTemperature;
        TrackingEntry."Vehicle No." := ShipmentHeader."Vehicle No.";
        TrackingEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(TrackingEntry."User ID"));
        OnBeforeInsertTrackingEntry(ShipmentHeader, TrackingEntry);
        TrackingEntry.Insert(true);

        if EventLocation <> '' then
            ShipmentHeader."Last Known Location" := EventLocation;
        ShipmentHeader."Last Status Update" := TrackingEntry."Event DateTime";
        ShipmentHeader.Modify();

        OnAfterInsertTrackingEntry(ShipmentHeader, TrackingEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTrackingEntry(ShipmentHeader: Record "LMS Shipment Header"; var TrackingEntry: Record "LMS Tracking Entry")
    begin
    end;

    /// <summary>Subscribe to notify customers (e-mail/SMS/webhook) on each tracking event.</summary>
    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertTrackingEntry(ShipmentHeader: Record "LMS Shipment Header"; TrackingEntry: Record "LMS Tracking Entry")
    begin
    end;
}
