/// <summary>
/// Classification of goods with the handling attributes that drive vehicle compatibility,
/// temperature, dangerous-goods, surcharge and insurance rules.
/// </summary>
table 50102 "LMS Goods Type"
{
    Caption = 'Goods Type';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Goods Types";
    DrillDownPageId = "LMS Goods Types";

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
        field(3; "Handling Class"; Enum "LMS Handling Class")
        {
            Caption = 'Handling Class';

            trigger OnValidate()
            begin
                case "Handling Class" of
                    "Handling Class"::Perishable, "Handling Class"::Frozen:
                        "Temperature Controlled" := true;
                    "Handling Class"::Hazardous:
                        Validate(Hazardous, true);
                end;
            end;
        }
        field(10; "Temperature Controlled"; Boolean)
        {
            Caption = 'Temperature Controlled';

            trigger OnValidate()
            begin
                if not "Temperature Controlled" then begin
                    "Min. Temperature (C)" := 0;
                    "Max. Temperature (C)" := 0;
                end;
            end;
        }
        field(11; "Min. Temperature (C)"; Decimal)
        {
            Caption = 'Min. Temperature (°C)';
            DecimalPlaces = 0 : 1;

            trigger OnValidate()
            begin
                CheckTemperatureRange();
            end;
        }
        field(12; "Max. Temperature (C)"; Decimal)
        {
            Caption = 'Max. Temperature (°C)';
            DecimalPlaces = 0 : 1;

            trigger OnValidate()
            begin
                CheckTemperatureRange();
            end;
        }
        field(20; Hazardous; Boolean)
        {
            Caption = 'Hazardous';

            trigger OnValidate()
            begin
                if not Hazardous then begin
                    "UN Number" := '';
                    "Hazard Class" := '';
                    "Packing Group" := '';
                end;
            end;
        }
        field(21; "UN Number"; Code[10])
        {
            Caption = 'UN Number';
        }
        field(22; "Hazard Class"; Code[10])
        {
            Caption = 'Hazard Class';
        }
        field(23; "Packing Group"; Code[5])
        {
            Caption = 'Packing Group';
        }
        field(30; Stackable; Boolean)
        {
            Caption = 'Stackable';
            InitValue = true;
        }
        field(31; "Min. Shelf Life (Days)"; Integer)
        {
            Caption = 'Min. Remaining Shelf Life (Days)';
            MinValue = 0;
        }
        field(40; "Handling Surcharge %"; Decimal)
        {
            Caption = 'Handling Surcharge %';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(41; "Insurance Rate %"; Decimal)
        {
            Caption = 'Insurance Rate %';
            DecimalPlaces = 0 : 3;
            MinValue = 0;
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
        fieldgroup(DropDown; "Code", Description, "Handling Class")
        {
        }
    }

    trigger OnDelete()
    var
        GoodsTypeVehicle: Record "LMS Goods Type Vehicle";
    begin
        GoodsTypeVehicle.SetRange("Goods Type Code", Code);
        GoodsTypeVehicle.DeleteAll();
    end;

    var
        TempRangeErr: Label 'Min. Temperature must not be higher than Max. Temperature.';

    local procedure CheckTemperatureRange()
    begin
        TestField("Temperature Controlled");
        if ("Min. Temperature (C)" <> 0) and ("Max. Temperature (C)" <> 0) then
            if "Min. Temperature (C)" > "Max. Temperature (C)" then
                Error(TempRangeErr);
    end;

    procedure IsVehicleTypeAllowed(VehicleType: Enum "LMS Vehicle Type"): Boolean
    var
        GoodsTypeVehicle: Record "LMS Goods Type Vehicle";
    begin
        GoodsTypeVehicle.SetRange("Goods Type Code", Code);
        if GoodsTypeVehicle.IsEmpty() then
            exit(true); // no restriction defined
        GoodsTypeVehicle.SetRange("Vehicle Type", VehicleType);
        exit(not GoodsTypeVehicle.IsEmpty());
    end;
}
