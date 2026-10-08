table 50113 "LMS Cue"
{
    Caption = 'Logistics Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Open Shipments"; Integer)
        {
            Caption = 'Open';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = const(Open)));
            Editable = false;
        }
        field(11; "Ready to Dispatch"; Integer)
        {
            Caption = 'Ready to Dispatch';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = filter(Released | Planned)));
            Editable = false;
        }
        field(12; "In Transit"; Integer)
        {
            Caption = 'In Transit';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = filter("Picked Up" | "In Transit" | "At Hub" | "Out for Delivery")));
            Editable = false;
        }
        field(13; Exceptions; Integer)
        {
            Caption = 'Exceptions';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = const(Exception)));
            Editable = false;
        }
        field(14; "Delivered Today"; Integer)
        {
            Caption = 'Delivered Today';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = const(Delivered), "Actual Delivery Date" = field("Date Filter")));
            Editable = false;
        }
        field(15; "Late Shipments"; Integer)
        {
            Caption = 'Late';
            FieldClass = FlowField;
            CalcFormula = count("LMS Shipment Header" where(Status = filter(Released | Planned | "Picked Up" | "In Transit" | "At Hub" | "Out for Delivery" | Exception), "Planned Delivery Date" = field("Overdue Date Filter")));
            Editable = false;
        }
        field(20; "Vehicles Available"; Integer)
        {
            Caption = 'Vehicles Available';
            FieldClass = FlowField;
            CalcFormula = count("LMS Vehicle" where(Status = const(Available)));
            Editable = false;
        }
        field(21; "Vehicles on Trip"; Integer)
        {
            Caption = 'Vehicles on Trip';
            FieldClass = FlowField;
            CalcFormula = count("LMS Vehicle" where(Status = const("On Trip")));
            Editable = false;
        }
        field(22; "Vehicles in Maintenance"; Integer)
        {
            Caption = 'Vehicles in Maintenance';
            FieldClass = FlowField;
            CalcFormula = count("LMS Vehicle" where(Status = const(Maintenance)));
            Editable = false;
        }
        field(30; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(31; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
