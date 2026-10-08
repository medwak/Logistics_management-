table 50104 "LMS Vehicle"
{
    Caption = 'Vehicle';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Vehicles";
    DrillDownPageId = "LMS Vehicles";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Vehicle Type"; Enum "LMS Vehicle Type")
        {
            Caption = 'Vehicle Type';

            trigger OnValidate()
            begin
                case "Vehicle Type" of
                    "Vehicle Type"::Aircraft:
                        "Transport Mode" := "Transport Mode"::Air;
                    "Vehicle Type"::Vessel:
                        "Transport Mode" := "Transport Mode"::Sea;
                    "Vehicle Type"::"Rail Wagon":
                        "Transport Mode" := "Transport Mode"::Rail;
                    "Vehicle Type"::"Reefer Truck":
                        "Temperature Controlled" := true;
                end;
            end;
        }
        field(4; "Registration No."; Text[30])
        {
            Caption = 'Registration No.';
        }
        field(5; "Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Transport Mode';
        }
        field(6; "Owned By"; Option)
        {
            Caption = 'Owned By';
            OptionMembers = Company,Subcontractor;
            OptionCaption = 'Company,Subcontractor';
        }
        field(7; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Subcontractor (Shipping Agent)';
            TableRelation = "Shipping Agent";
        }
        field(10; "Max. Weight (kg)"; Decimal)
        {
            Caption = 'Max. Payload (kg)';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(11; "Max. Volume (m3)"; Decimal)
        {
            Caption = 'Max. Volume (m³)';
            DecimalPlaces = 0 : 3;
            MinValue = 0;
        }
        field(12; "Max. Pallets"; Integer)
        {
            Caption = 'Max. Pallets';
            MinValue = 0;
        }
        field(20; "Temperature Controlled"; Boolean)
        {
            Caption = 'Temperature Controlled';
        }
        field(21; "Min. Temperature (C)"; Decimal)
        {
            Caption = 'Min. Temperature (°C)';
            DecimalPlaces = 0 : 1;
        }
        field(22; "Max. Temperature (C)"; Decimal)
        {
            Caption = 'Max. Temperature (°C)';
            DecimalPlaces = 0 : 1;
        }
        field(23; "Hazmat Certified"; Boolean)
        {
            Caption = 'Hazmat Certified';
        }
        field(30; Status; Enum "LMS Resource Status")
        {
            Caption = 'Status';
        }
        field(31; "Location Code"; Code[10])
        {
            Caption = 'Home Location Code';
            TableRelation = Location;
        }
        field(32; "Default Driver No."; Code[20])
        {
            Caption = 'Default Driver No.';
            TableRelation = "LMS Driver";
        }
        field(40; "Cost per Km"; Decimal)
        {
            Caption = 'Cost per Km';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(41; "Next Service Date"; Date)
        {
            Caption = 'Next Service Date';
        }
        field(42; "Insurance Expiry Date"; Date)
        {
            Caption = 'Insurance Expiry Date';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; Status, "Vehicle Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Vehicle Type", "Registration No.", Status)
        {
        }
    }
}
