/// <summary>
/// Vehicle types allowed to carry a goods type. No entries for a goods type means any vehicle is allowed.
/// </summary>
table 50103 "LMS Goods Type Vehicle"
{
    Caption = 'Goods Type Allowed Vehicle';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Goods Type Code"; Code[20])
        {
            Caption = 'Goods Type Code';
            TableRelation = "LMS Goods Type";
            NotBlank = true;
        }
        field(2; "Vehicle Type"; Enum "LMS Vehicle Type")
        {
            Caption = 'Vehicle Type';
        }
    }

    keys
    {
        key(PK; "Goods Type Code", "Vehicle Type")
        {
            Clustered = true;
        }
    }
}
