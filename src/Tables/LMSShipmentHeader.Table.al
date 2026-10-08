table 50108 "LMS Shipment Header"
{
    Caption = 'Logistics Shipment';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Shipments";
    DrillDownPageId = "LMS Shipments";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    GetSetup();
                    NoSeries.TestManual(LMSSetup."Shipment Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "LMS Industry Profile";

            trigger OnValidate()
            var
                IndustryProfile: Record "LMS Industry Profile";
            begin
                TestStatusOpen();
                if "Industry Code" = '' then begin
                    "Industry Type" := "Industry Type"::General;
                    exit;
                end;
                IndustryProfile.Get("Industry Code");
                "Industry Type" := IndustryProfile."Industry Type";
                "Transport Mode" := IndustryProfile."Default Transport Mode";
            end;
        }
        field(3; "Industry Type"; Enum "LMS Industry Type")
        {
            Caption = 'Industry Type';
            Editable = false;
        }
        field(4; Status; Enum "LMS Shipment Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                TestStatusOpen();
                if "Customer No." = '' then begin
                    "Customer Name" := '';
                    exit;
                end;
                Customer.Get("Customer No.");
                "Customer Name" := Customer.Name;
                "Ship-to Name" := Customer.Name;
                "Ship-to Address" := Customer.Address;
                "Ship-to Address 2" := Customer."Address 2";
                "Ship-to City" := Customer.City;
                "Ship-to Post Code" := Customer."Post Code";
                "Ship-to Country/Region Code" := Customer."Country/Region Code";
                "Ship-to Contact" := Customer.Contact;
                "Ship-to Phone No." := Customer."Phone No.";
                if Customer."Location Code" <> '' then
                    "Ship-from Location Code" := Customer."Location Code";
                if Customer."Shipping Agent Code" <> '' then
                    "Shipping Agent Code" := Customer."Shipping Agent Code";
                if Customer."LMS Industry Code" <> '' then
                    Validate("Industry Code", Customer."LMS Industry Code");
            end;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(12; "Ship-from Location Code"; Code[10])
        {
            Caption = 'Ship-from Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(20; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(21; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(22; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(23; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(24; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
        field(25; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(26; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(27; "Ship-to Phone No."; Text[30])
        {
            Caption = 'Ship-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(30; "Transport Mode"; Enum "LMS Transport Mode")
        {
            Caption = 'Transport Mode';

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(31; "Route Code"; Code[20])
        {
            Caption = 'Route Code';
            TableRelation = "LMS Route";

            trigger OnValidate()
            var
                Route: Record "LMS Route";
                TransitDays: Integer;
            begin
                TestStatusOpen();
                if "Route Code" = '' then
                    exit;
                Route.Get("Route Code");
                "Transport Mode" := Route."Transport Mode";
                "Distance (km)" := Route."Distance (km)";
                if ("Planned Delivery Date" = 0D) and ("Shipment Date" <> 0D) then begin
                    TransitDays := Round(Route."Est. Transit Hours" / 24, 1, '>');
                    "Planned Delivery Date" := "Shipment Date" + TransitDays;
                end;
            end;
        }
        field(32; "Distance (km)"; Decimal)
        {
            Caption = 'Distance (km)';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
        }
        field(33; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Carrier (Shipping Agent)';
            TableRelation = "Shipping Agent";
        }
        field(34; "Vehicle No."; Code[20])
        {
            Caption = 'Vehicle No.';
            TableRelation = "LMS Vehicle";

            trigger OnValidate()
            var
                Vehicle: Record "LMS Vehicle";
            begin
                if not (Status in [Status::Open, Status::Released, Status::Planned]) then
                    FieldError(Status);
                if "Vehicle No." = '' then
                    exit;
                Vehicle.Get("Vehicle No.");
                if ("Driver No." = '') and (Vehicle."Default Driver No." <> '') then
                    "Driver No." := Vehicle."Default Driver No.";
                if (Vehicle."Shipping Agent Code" <> '') and ("Shipping Agent Code" = '') then
                    "Shipping Agent Code" := Vehicle."Shipping Agent Code";
            end;
        }
        field(35; "Driver No."; Code[20])
        {
            Caption = 'Driver No.';
            TableRelation = "LMS Driver";

            trigger OnValidate()
            begin
                if not (Status in [Status::Open, Status::Released, Status::Planned]) then
                    FieldError(Status);
            end;
        }
        field(36; "Tracking No."; Text[50])
        {
            Caption = 'Carrier Tracking No.';
        }
        field(40; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(41; "Planned Delivery Date"; Date)
        {
            Caption = 'Planned Delivery Date';
        }
        field(42; "Actual Pickup DateTime"; DateTime)
        {
            Caption = 'Actual Pickup Date/Time';
            Editable = false;
        }
        field(43; "Actual Delivery Date"; Date)
        {
            Caption = 'Actual Delivery Date';
            Editable = false;
        }
        field(44; "Actual Delivery DateTime"; DateTime)
        {
            Caption = 'Actual Delivery Date/Time';
            Editable = false;
        }
        field(50; "Source Document Type"; Enum "LMS Source Document Type")
        {
            Caption = 'Source Document Type';
            Editable = false;
        }
        field(51; "Source Document No."; Code[20])
        {
            Caption = 'Source Document No.';
            Editable = false;
        }
        field(52; "External Reference"; Text[50])
        {
            Caption = 'External Reference';
        }
        field(60; "Total Gross Weight (kg)"; Decimal)
        {
            Caption = 'Total Gross Weight (kg)';
            FieldClass = FlowField;
            CalcFormula = sum("LMS Shipment Line"."Gross Weight (kg)" where("Shipment No." = field("No.")));
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(61; "Total Volume (m3)"; Decimal)
        {
            Caption = 'Total Volume (m³)';
            FieldClass = FlowField;
            CalcFormula = sum("LMS Shipment Line"."Volume (m3)" where("Shipment No." = field("No.")));
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(62; "Total Pallets"; Decimal)
        {
            Caption = 'Total Pallets';
            FieldClass = FlowField;
            CalcFormula = sum("LMS Shipment Line"."No. of Pallets" where("Shipment No." = field("No.")));
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(63; "Total Declared Value"; Decimal)
        {
            Caption = 'Total Declared Value';
            FieldClass = FlowField;
            CalcFormula = sum("LMS Shipment Line"."Declared Value" where("Shipment No." = field("No.")));
            AutoFormatType = 1;
            Editable = false;
        }
        field(64; "No. of Lines"; Integer)
        {
            Caption = 'No. of Lines';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Line" where("Shipment No." = field("No."), Type = filter(Item | "Customer Goods")));
            Editable = false;
        }
        field(70; "Contains Hazardous Goods"; Boolean)
        {
            Caption = 'Contains Hazardous Goods';
            Editable = false;
        }
        field(71; "Temperature Controlled"; Boolean)
        {
            Caption = 'Temperature Controlled';
            Editable = false;
        }
        field(72; "Required Min. Temp. (C)"; Decimal)
        {
            Caption = 'Required Min. Temp. (°C)';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(73; "Required Max. Temp. (C)"; Decimal)
        {
            Caption = 'Required Max. Temp. (°C)';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(80; "Freight Charge"; Decimal)
        {
            Caption = 'Freight Charge';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                UpdateTotalCharge();
            end;
        }
        field(81; "Surcharge Amount"; Decimal)
        {
            Caption = 'Handling Surcharge';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                UpdateTotalCharge();
            end;
        }
        field(82; "Insurance Amount"; Decimal)
        {
            Caption = 'Insurance Amount';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                UpdateTotalCharge();
            end;
        }
        field(83; "Total Charge"; Decimal)
        {
            Caption = 'Total Charge';
            AutoFormatType = 1;
            Editable = false;
        }
        field(84; "Applied Freight Rate No."; Integer)
        {
            Caption = 'Applied Freight Rate Entry No.';
            TableRelation = "LMS Freight Rate";
            Editable = false;
        }
        field(90; "POD Received By"; Text[100])
        {
            Caption = 'Proof of Delivery - Received By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(91; "Last Known Location"; Text[100])
        {
            Caption = 'Last Known Location';
            Editable = false;
        }
        field(92; "Last Status Update"; DateTime)
        {
            Caption = 'Last Status Update';
            Editable = false;
        }
        field(100; "Special Instructions"; Text[250])
        {
            Caption = 'Special Instructions';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; Status, "Shipment Date")
        {
        }
        key(Customer; "Customer No.", "Shipment Date")
        {
        }
        key(Source; "Source Document Type", "Source Document No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Customer Name", "Ship-to City", Status, "Shipment Date")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        GetSetup();
        if "No." = '' then begin
            LMSSetup.TestField("Shipment Nos.");
            "No. Series" := LMSSetup."Shipment Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
        if "Shipment Date" = 0D then
            "Shipment Date" := WorkDate();
        if "Industry Code" = '' then
            if LMSSetup."Default Industry Code" <> '' then
                Validate("Industry Code", LMSSetup."Default Industry Code")
            else
                "Transport Mode" := LMSSetup."Default Transport Mode";
    end;

    trigger OnDelete()
    var
        ShipmentLine: Record "LMS Shipment Line";
        ShipmentDocument: Record "LMS Shipment Document";
        TrackingEntry: Record "LMS Tracking Entry";
    begin
        if not (Status in [Status::Open, Status::Cancelled, Status::Delivered]) then
            Error(CannotDeleteErr, "No.", Status);

        ShipmentLine.SetRange("Shipment No.", "No.");
        ShipmentLine.DeleteAll();
        ShipmentDocument.SetRange("Shipment No.", "No.");
        ShipmentDocument.DeleteAll();
        TrackingEntry.SetRange("Shipment No.", "No.");
        TrackingEntry.DeleteAll();
    end;

    trigger OnRename()
    begin
        Error(RenameErr, TableCaption());
    end;

    var
        LMSSetup: Record "LMS Setup";
        CannotDeleteErr: Label 'Shipment %1 cannot be deleted while its status is %2.', Comment = '%1 = shipment no., %2 = status';
        RenameErr: Label 'You cannot rename a %1.', Comment = '%1 = table caption';

    procedure TestStatusOpen()
    begin
        TestField(Status, Status::Open);
    end;

    procedure AssistEdit(OldShipmentHeader: Record "LMS Shipment Header"): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        GetSetup();
        LMSSetup.TestField("Shipment Nos.");
        if NoSeries.LookupRelatedNoSeries(LMSSetup."Shipment Nos.", OldShipmentHeader."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    procedure IsCrossBorder(): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        if "Ship-to Country/Region Code" = '' then
            exit(false);
        CompanyInformation.Get();
        exit("Ship-to Country/Region Code" <> CompanyInformation."Country/Region Code");
    end;

    procedure IsInTransit(): Boolean
    begin
        exit(Status in [Status::"Picked Up", Status::"In Transit", Status::"At Hub", Status::"Out for Delivery", Status::Exception]);
    end;

    procedure GetStatusStyle(): Text
    begin
        case Status of
            Status::Delivered:
                exit('Favorable');
            Status::Exception, Status::Cancelled:
                exit('Unfavorable');
            Status::"Picked Up", Status::"In Transit", Status::"At Hub", Status::"Out for Delivery":
                exit('StrongAccent');
        end;
        if ("Planned Delivery Date" <> 0D) and ("Planned Delivery Date" < WorkDate()) then
            exit('Attention');
        exit('Standard');
    end;

    local procedure UpdateTotalCharge()
    begin
        "Total Charge" := "Freight Charge" + "Surcharge Amount" + "Insurance Amount";
    end;

    local procedure GetSetup()
    begin
        LMSSetup.GetRecordOnce();
    end;
}
