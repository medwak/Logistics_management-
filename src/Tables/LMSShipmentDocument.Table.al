table 50112 "LMS Shipment Document"
{
    Caption = 'Shipment Document';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = "LMS Shipment Header";
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
        field(4; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
        }
        field(5; Received; Boolean)
        {
            Caption = 'Received / Attached';

            trigger OnValidate()
            begin
                if Received then begin
                    "Received Date" := WorkDate();
                    "Received By" := CopyStr(UserId(), 1, MaxStrLen("Received By"));
                end else begin
                    "Received Date" := 0D;
                    "Received By" := '';
                end;
            end;
        }
        field(6; "Reference No."; Text[50])
        {
            Caption = 'Reference No.';
        }
        field(7; "Received Date"; Date)
        {
            Caption = 'Received Date';
            Editable = false;
        }
        field(8; "Received By"; Code[50])
        {
            Caption = 'Received By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(9; "Auto-Generated"; Boolean)
        {
            Caption = 'Auto-Generated';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Shipment No.", "Document Code")
        {
            Clustered = true;
        }
    }
}
