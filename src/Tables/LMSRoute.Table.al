table 50106 "LMS Route"
{
    Caption = 'Route';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Routes";
    DrillDownPageId = "LMS Routes";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Origin Location Code"; Code[10])
        {
            Caption = 'Origin Location Code';
            TableRelation = Location;
        }
        field(4; Origin; Text[100])
        {
            Caption = 'Origin';
        }
        field(5; Destination; Text[100])
        {
            Caption = 'Destination';
        }
        field(6; "Destination Country Code"; Code[10])
        {
            Caption = 'Destination Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(10; "Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Transport Mode';
        }
        field(11; "Distance (km)"; Decimal)
        {
            Caption = 'Distance (km)';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
        }
        field(12; "Est. Transit Hours"; Decimal)
        {
            Caption = 'Est. Transit Hours';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
        }
        field(13; "Zone Code"; Code[10])
        {
            Caption = 'Rate Zone Code';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, Origin, Destination, "Transport Mode")
        {
        }
    }
}
