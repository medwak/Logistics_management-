/// <summary>
/// Freight tariff. The most specific match wins: goods type + zone, goods type, zone, then generic.
/// Within a match, the latest starting date and the highest weight break not above the shipment weight apply.
/// </summary>
table 50107 "LMS Freight Rate"
{
    Caption = 'Freight Rate';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Freight Rates";
    DrillDownPageId = "LMS Freight Rates";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Transport Mode';
        }
        field(3; "Goods Type Code"; Code[20])
        {
            Caption = 'Goods Type Code';
            TableRelation = "LMS Goods Type";
        }
        field(4; "Zone Code"; Code[10])
        {
            Caption = 'Zone Code';
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(6; "Minimum Weight (kg)"; Decimal)
        {
            Caption = 'From Weight (kg)';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(10; "Rate Basis"; Enum "LMS Rate Basis")
        {
            Caption = 'Rate Basis';
        }
        field(11; Rate; Decimal)
        {
            Caption = 'Rate';
            DecimalPlaces = 2 : 5;
            MinValue = 0;
        }
        field(12; "Minimum Charge"; Decimal)
        {
            Caption = 'Minimum Charge';
            AutoFormatType = 1;
            MinValue = 0;
        }
        field(13; "Volumetric Factor (kg/m3)"; Decimal)
        {
            Caption = 'Volumetric Factor (kg/m³)';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Lookup; "Transport Mode", "Goods Type Code", "Zone Code", "Starting Date", "Minimum Weight (kg)")
        {
        }
    }
}
