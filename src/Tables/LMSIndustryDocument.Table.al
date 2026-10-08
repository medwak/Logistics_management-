/// <summary>
/// Documents an industry requires on its shipments, optionally only under a condition
/// (hazardous goods, cold chain, cross-border, ...). A blank Industry Code applies to all industries.
/// </summary>
table 50111 "LMS Industry Document"
{
    Caption = 'Industry Required Document';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "LMS Industry Profile";
        }
        field(2; "Document Code"; Code[20])
        {
            Caption = 'Document Code';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; Condition; Enum "LMS Document Condition")
        {
            Caption = 'Required When';
        }
        field(5; Mandatory; Boolean)
        {
            Caption = 'Mandatory for Release';
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Industry Code", "Document Code")
        {
            Clustered = true;
        }
    }
}
