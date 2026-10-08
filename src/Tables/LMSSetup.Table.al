table 50100 "LMS Setup"
{
    Caption = 'Logistics Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Shipment Nos."; Code[20])
        {
            Caption = 'Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Default Industry Code"; Code[20])
        {
            Caption = 'Default Industry Code';
            TableRelation = "LMS Industry Profile";
        }
        field(21; "Default Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Default Transport Mode';
        }
        field(30; "Volumetric Factor (kg/m3)"; Decimal)
        {
            Caption = 'Volumetric Factor (kg/m3)';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            InitValue = 250;
        }
        field(40; "Block Release on Warnings"; Boolean)
        {
            Caption = 'Block Release on Warnings';
        }
        field(41; "Auto-Calc. Charges on Release"; Boolean)
        {
            Caption = 'Auto-Calc. Charges on Release';
            InitValue = true;
        }
        field(50; "Expiry Warning Days"; Integer)
        {
            Caption = 'Expiry Warning Days';
            MinValue = 0;
            InitValue = 30;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        if not Get() then begin
            Init();
            Insert();
        end;
        RecordHasBeenRead := true;
    end;
}
