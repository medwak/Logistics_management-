enum 50101 "LMS Handling Class"
{
    Extensible = true;
    Caption = 'Handling Class';

    value(0; Standard)
    {
        Caption = 'Standard';
    }
    value(1; Fragile)
    {
        Caption = 'Fragile';
    }
    value(2; Perishable)
    {
        Caption = 'Perishable (Chilled)';
    }
    value(3; Frozen)
    {
        Caption = 'Frozen';
    }
    value(4; Hazardous)
    {
        Caption = 'Hazardous / Dangerous Goods';
    }
    value(5; "Bulk Liquid")
    {
        Caption = 'Bulk Liquid';
    }
    value(6; "Bulk Dry")
    {
        Caption = 'Bulk Dry';
    }
    value(7; Oversized)
    {
        Caption = 'Oversized / Heavy Lift';
    }
    value(8; "High Value")
    {
        Caption = 'High Value';
    }
    value(9; "Live Animals")
    {
        Caption = 'Live Animals';
    }
}
