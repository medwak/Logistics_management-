table 50105 "LMS Driver"
{
    Caption = 'Driver';
    DataClassification = CustomerContent;
    LookupPageId = "LMS Drivers";
    DrillDownPageId = "LMS Drivers";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if "Employee No." = '' then
                    exit;
                Employee.Get("Employee No.");
                if Name = '' then
                    Name := CopyStr(Employee.FullName(), 1, MaxStrLen(Name));
                if "Phone No." = '' then
                    "Phone No." := Employee."Mobile Phone No.";
            end;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; "License No."; Text[30])
        {
            Caption = 'License No.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; "License Class"; Code[10])
        {
            Caption = 'License Class';
        }
        field(12; "License Expiry Date"; Date)
        {
            Caption = 'License Expiry Date';
        }
        field(20; "Hazmat Certified"; Boolean)
        {
            Caption = 'Hazmat (ADR) Certified';
        }
        field(21; "Hazmat Cert. Expiry Date"; Date)
        {
            Caption = 'Hazmat Cert. Expiry Date';
        }
        field(30; Status; Enum "LMS Resource Status")
        {
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Phone No.", Status)
        {
        }
    }
}
