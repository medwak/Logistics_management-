/// <summary>
/// Industry served by a shipment. Each value plugs its own compliance rules in through
/// the "LMS IIndustry Compliance" interface. Extend this enum (enumextension) to add industries.
/// </summary>
enum 50100 "LMS Industry Type" implements "LMS IIndustry Compliance"
{
    Extensible = true;
    Caption = 'Industry Type';
    DefaultImplementation = "LMS IIndustry Compliance" = "LMS General Compliance";

    value(0; General)
    {
        Caption = 'General';
    }
    value(1; Pharmaceutical)
    {
        Caption = 'Pharmaceutical & Healthcare';
        Implementation = "LMS IIndustry Compliance" = "LMS Pharma Compliance";
    }
    value(2; "Food & Beverage")
    {
        Caption = 'Food & Beverage';
        Implementation = "LMS IIndustry Compliance" = "LMS Food Compliance";
    }
    value(3; Automotive)
    {
        Caption = 'Automotive';
        Implementation = "LMS IIndustry Compliance" = "LMS High Value Compliance";
    }
    value(4; Retail)
    {
        Caption = 'Retail & E-Commerce';
    }
    value(5; Construction)
    {
        Caption = 'Construction';
        Implementation = "LMS IIndustry Compliance" = "LMS Heavy Cargo Compliance";
    }
    value(6; Chemicals)
    {
        Caption = 'Chemicals';
        Implementation = "LMS IIndustry Compliance" = "LMS Dangerous Goods Compliance";
    }
    value(7; Agriculture)
    {
        Caption = 'Agriculture';
        Implementation = "LMS IIndustry Compliance" = "LMS Food Compliance";
    }
    value(8; Electronics)
    {
        Caption = 'Electronics & Technology';
        Implementation = "LMS IIndustry Compliance" = "LMS High Value Compliance";
    }
    value(9; "Oil & Gas")
    {
        Caption = 'Oil & Gas';
        Implementation = "LMS IIndustry Compliance" = "LMS Dangerous Goods Compliance";
    }
    value(10; Textile)
    {
        Caption = 'Textile & Apparel';
    }
    value(11; Mining)
    {
        Caption = 'Mining';
        Implementation = "LMS IIndustry Compliance" = "LMS Heavy Cargo Compliance";
    }
}
