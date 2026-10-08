/// <summary>
/// Configurable profile describing how an industry ships goods. Customers are linked to a profile
/// and every shipment inherits its rules (tracking, temperature, hazmat, customs, POD, insurance).
/// </summary>
table 50101 "LMS Industry Profile"
{
    Caption = 'Industry Profile';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Industry Profiles";
    DrillDownPageId = "LMS Industry Profiles";

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
        field(3; "Industry Type"; Enum "LMS Industry Type")
        {
            Caption = 'Industry Type';
        }
        field(10; "Requires Lot Tracking"; Boolean)
        {
            Caption = 'Requires Lot Tracking';
        }
        field(11; "Requires Serial Tracking"; Boolean)
        {
            Caption = 'Requires Serial Tracking';
        }
        field(12; "Requires Temp. Control"; Boolean)
        {
            Caption = 'Requires Temperature Control';
        }
        field(13; "Requires Hazmat Handling"; Boolean)
        {
            Caption = 'Requires Hazmat Handling';
        }
        field(14; "Requires Customs Data"; Boolean)
        {
            Caption = 'Requires Customs Data';
        }
        field(15; "Requires Proof of Delivery"; Boolean)
        {
            Caption = 'Requires Proof of Delivery';
        }
        field(16; "Requires Insurance"; Boolean)
        {
            Caption = 'Requires Insurance';
        }
        field(20; "Max. Transit Hours"; Decimal)
        {
            Caption = 'Max. Transit Hours';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
        }
        field(21; "Default Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Default Transport Mode';
        }
        field(22; "Default Goods Type Code"; Code[20])
        {
            Caption = 'Default Goods Type Code';
            TableRelation = "LMS Goods Type";
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
        fieldgroup(DropDown; "Code", Description, "Industry Type")
        {
        }
    }
}
