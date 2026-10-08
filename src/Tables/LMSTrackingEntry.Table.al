table 50110 "LMS Tracking Entry"
{
    Caption = 'Shipment Tracking Entry';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Tracking Entries";
    DrillDownPageId = "LMS Tracking Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = "LMS Shipment Header";
        }
        field(3; "Event DateTime"; DateTime)
        {
            Caption = 'Event Date/Time';
        }
        field(4; Status; Enum "LMS Shipment Status")
        {
            Caption = 'Status';
        }
        field(5; Location; Text[100])
        {
            Caption = 'Location';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(7; Latitude; Decimal)
        {
            Caption = 'Latitude';
            DecimalPlaces = 0 : 6;
        }
        field(8; Longitude; Decimal)
        {
            Caption = 'Longitude';
            DecimalPlaces = 0 : 6;
        }
        field(9; "Temperature (C)"; Decimal)
        {
            Caption = 'Recorded Temperature (°C)';
            DecimalPlaces = 0 : 1;
        }
        field(10; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
            TableRelation = "LMS Vehicle";
        }
        field(11; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Shipment; "Shipment No.", "Event DateTime")
        {
        }
    }
}
