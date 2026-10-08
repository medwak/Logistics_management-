page 50107 "LMS Drivers"
{
    Caption = 'Drivers';
    PageType = List;
    SourceTable = "LMS Driver";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the driver number.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the driver.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the related employee.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the phone number.';
                }
                field("License No."; Rec."License No.")
                {
                    ToolTip = 'Specifies the driving license number.';
                }
                field("License Class"; Rec."License Class")
                {
                    ToolTip = 'Specifies the license class.';
                }
                field("License Expiry Date"; Rec."License Expiry Date")
                {
                    ToolTip = 'Specifies when the driving license expires.';
                }
                field("Hazmat Certified"; Rec."Hazmat Certified")
                {
                    ToolTip = 'Specifies whether the driver holds a dangerous goods (ADR) certificate.';
                }
                field("Hazmat Cert. Expiry Date"; Rec."Hazmat Cert. Expiry Date")
                {
                    ToolTip = 'Specifies when the dangerous goods certificate expires.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the availability of the driver.';
                }
            }
        }
    }
}
