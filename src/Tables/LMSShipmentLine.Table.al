/// <summary>
/// A line of goods on a shipment. Supports company items and third-party (customer-owned) goods
/// that are not in the item master, so the module works for both shippers and 3PL providers.
/// </summary>
table 50109 "LMS Shipment Line"
{
    Caption = 'Logistics Shipment Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = "LMS Shipment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Enum "LMS Shipment Line Type")
        {
            Caption = 'Type';

            trigger OnValidate()
            var
                TempLine: Record "LMS Shipment Line" temporary;
            begin
                TestStatusOpen();
                if Type = xRec.Type then
                    exit;
                TempLine := Rec;
                Init();
                "Shipment No." := TempLine."Shipment No.";
                "Line No." := TempLine."Line No.";
                Type := TempLine.Type;
                if Type = Type::"Customer Goods" then
                    ApplyDefaultGoodsType();
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Item)) Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                TestStatusOpen();
                if Type <> Type::Item then
                    exit;
                if "No." = '' then
                    exit;
                Item.Get("No.");
                Item.TestField(Blocked, false);
                Description := Item.Description;
                "Tariff No." := Item."Tariff No.";
                "Declared Unit Value" := Item."Unit Price";
                if Item."LMS Goods Type Code" <> '' then
                    Validate("Goods Type Code", Item."LMS Goods Type Code")
                else
                    ApplyDefaultGoodsType();
                Validate("Unit of Measure Code", Item."Base Unit of Measure");
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Goods Type Code"; Code[20])
        {
            Caption = 'Goods Type Code';
            TableRelation = "LMS Goods Type";

            trigger OnValidate()
            var
                GoodsType: Record "LMS Goods Type";
            begin
                TestStatusOpen();
                if "Goods Type Code" = '' then begin
                    "Handling Class" := "Handling Class"::Standard;
                    "Temperature Controlled" := false;
                    "Min. Temperature (C)" := 0;
                    "Max. Temperature (C)" := 0;
                    Hazardous := false;
                    "UN Number" := '';
                    "Hazard Class" := '';
                    "Packing Group" := '';
                    exit;
                end;
                GoodsType.Get("Goods Type Code");
                "Handling Class" := GoodsType."Handling Class";
                "Temperature Controlled" := GoodsType."Temperature Controlled";
                "Min. Temperature (C)" := GoodsType."Min. Temperature (C)";
                "Max. Temperature (C)" := GoodsType."Max. Temperature (C)";
                Hazardous := GoodsType.Hazardous;
                "UN Number" := GoodsType."UN Number";
                "Hazard Class" := GoodsType."Hazard Class";
                "Packing Group" := GoodsType."Packing Group";
            end;
        }
        field(7; "Handling Class"; Enum "LMS Handling Class")
        {
            Caption = 'Handling Class';
        }
        field(10; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen();
                UpdateAmounts();
            end;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure";

            trigger OnValidate()
            var
                Item: Record Item;
                ItemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                TestStatusOpen();
                if (Type = Type::Item) and ("No." <> '') then begin
                    Item.Get("No.");
                    if ItemUnitOfMeasure.Get("No.", "Unit of Measure Code") then begin
                        if ItemUnitOfMeasure.Weight <> 0 then
                            "Unit Weight (kg)" := ItemUnitOfMeasure.Weight
                        else
                            "Unit Weight (kg)" := Item."Gross Weight" * ItemUnitOfMeasure."Qty. per Unit of Measure";
                        if ItemUnitOfMeasure.Cubage <> 0 then
                            "Unit Volume (m3)" := ItemUnitOfMeasure.Cubage
                        else
                            "Unit Volume (m3)" := Item."Unit Volume" * ItemUnitOfMeasure."Qty. per Unit of Measure";
                        "Declared Unit Value" := Item."Unit Price" * ItemUnitOfMeasure."Qty. per Unit of Measure";
                    end else begin
                        "Unit Weight (kg)" := Item."Gross Weight";
                        "Unit Volume (m3)" := Item."Unit Volume";
                    end;
                end;
                UpdateAmounts();
            end;
        }
        field(12; "Unit Weight (kg)"; Decimal)
        {
            Caption = 'Unit Gross Weight (kg)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen();
                UpdateAmounts();
            end;
        }
        field(13; "Unit Volume (m3)"; Decimal)
        {
            Caption = 'Unit Volume (m³)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen();
                UpdateAmounts();
            end;
        }
        field(14; "Gross Weight (kg)"; Decimal)
        {
            Caption = 'Gross Weight (kg)';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(15; "Volume (m3)"; Decimal)
        {
            Caption = 'Volume (m³)';
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(16; "No. of Pallets"; Decimal)
        {
            Caption = 'No. of Pallets';
            DecimalPlaces = 0 : 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(17; "No. of Packages"; Integer)
        {
            Caption = 'No. of Packages';
            MinValue = 0;
        }
        field(20; "Declared Unit Value"; Decimal)
        {
            Caption = 'Declared Unit Value';
            AutoFormatType = 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen();
                UpdateAmounts();
            end;
        }
        field(21; "Declared Value"; Decimal)
        {
            Caption = 'Declared Value';
            AutoFormatType = 1;
            Editable = false;
        }
        field(30; "Lot No."; Code[50])
        {
            Caption = 'Lot / Batch No.';
        }
        field(31; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(32; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(33; "Tariff No."; Code[20])
        {
            Caption = 'HS Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(34; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }
        field(40; "Temperature Controlled"; Boolean)
        {
            Caption = 'Temperature Controlled';
        }
        field(41; "Min. Temperature (C)"; Decimal)
        {
            Caption = 'Min. Temperature (°C)';
            DecimalPlaces = 0 : 1;
        }
        field(42; "Max. Temperature (C)"; Decimal)
        {
            Caption = 'Max. Temperature (°C)';
            DecimalPlaces = 0 : 1;
        }
        field(50; Hazardous; Boolean)
        {
            Caption = 'Hazardous';
        }
        field(51; "UN Number"; Code[10])
        {
            Caption = 'UN Number';
        }
        field(52; "Hazard Class"; Code[10])
        {
            Caption = 'Hazard Class';
        }
        field(53; "Packing Group"; Code[5])
        {
            Caption = 'Packing Group';
        }
    }

    keys
    {
        key(PK; "Shipment No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Gross Weight (kg)", "Volume (m3)", "No. of Pallets", "Declared Value";
        }
    }

    trigger OnInsert()
    begin
        TestStatusOpen();
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;

    var
        ShipmentHeader: Record "LMS Shipment Header";

    local procedure TestStatusOpen()
    begin
        if "Shipment No." = '' then
            exit;
        ShipmentHeader.Get("Shipment No.");
        ShipmentHeader.TestStatusOpen();
    end;

    local procedure UpdateAmounts()
    begin
        "Gross Weight (kg)" := Round(Quantity * "Unit Weight (kg)", 0.001);
        "Volume (m3)" := Round(Quantity * "Unit Volume (m3)", 0.001);
        "Declared Value" := Round(Quantity * "Declared Unit Value");
    end;

    local procedure ApplyDefaultGoodsType()
    var
        IndustryProfile: Record "LMS Industry Profile";
    begin
        if "Goods Type Code" <> '' then
            exit;
        if not ShipmentHeader.Get("Shipment No.") then
            exit;
        if not IndustryProfile.Get(ShipmentHeader."Industry Code") then
            exit;
        if IndustryProfile."Default Goods Type Code" <> '' then
            Validate("Goods Type Code", IndustryProfile."Default Goods Type Code");
    end;
}
