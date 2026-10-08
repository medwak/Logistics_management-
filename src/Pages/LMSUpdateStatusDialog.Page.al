page 50118 "LMS Update Status Dialog"
{
    Caption = 'Update Shipment Status';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Current)
            {
                Caption = 'Shipment';
                field(ShipmentNo; ShipmentNo)
                {
                    Caption = 'Shipment No.';
                    Editable = false;
                    ToolTip = 'Specifies the shipment.';
                }
                field(CurrentStatus; CurrentStatus)
                {
                    Caption = 'Current Status';
                    Editable = false;
                    ToolTip = 'Specifies the current status.';
                }
            }
            group(NewEvent)
            {
                Caption = 'New Event';
                field(NewStatus; NewStatus)
                {
                    Caption = 'New Status';
                    ToolTip = 'Specifies the new status.';
                }
                field(EventLocation; EventLocation)
                {
                    Caption = 'Location';
                    ToolTip = 'Specifies where the event happened, such as a hub, border post or city.';
                }
                field(EventDescription; EventDescription)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies details, such as the reason for an exception.';
                }
                field(ReceivedBy; ReceivedBy)
                {
                    Caption = 'Received By (Proof of Delivery)';
                    ToolTip = 'Specifies who signed for the goods. Required on delivery when the industry profile requires proof of delivery.';
                }
            }
        }
    }

    var
        ShipmentNo: Code[20];
        CurrentStatus: Enum "LMS Shipment Status";
        NewStatus: Enum "LMS Shipment Status";
        EventLocation: Text[100];
        EventDescription: Text[250];
        ReceivedBy: Text[100];

    procedure SetShipment(ShipmentHeader: Record "LMS Shipment Header")
    begin
        ShipmentNo := ShipmentHeader."No.";
        CurrentStatus := ShipmentHeader.Status;
        case CurrentStatus of
            CurrentStatus::Released, CurrentStatus::Planned:
                NewStatus := NewStatus::"Picked Up";
            CurrentStatus::"Picked Up", CurrentStatus::"At Hub", CurrentStatus::Exception:
                NewStatus := NewStatus::"In Transit";
            CurrentStatus::"In Transit":
                NewStatus := NewStatus::"Out for Delivery";
            CurrentStatus::"Out for Delivery":
                NewStatus := NewStatus::Delivered;
            else
                NewStatus := CurrentStatus;
        end;
        EventLocation := ShipmentHeader."Last Known Location";
    end;

    procedure GetNewStatus(): Enum "LMS Shipment Status"
    begin
        exit(NewStatus);
    end;

    procedure GetLocation(): Text[100]
    begin
        exit(EventLocation);
    end;

    procedure GetDescription(): Text[250]
    begin
        exit(EventDescription);
    end;

    procedure GetReceivedBy(): Text[100]
    begin
        exit(ReceivedBy);
    end;
}
