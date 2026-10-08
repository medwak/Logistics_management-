enum 50106 "LMS Resource Status"
{
    Extensible = true;
    Caption = 'Resource Status';

    value(0; Available)
    {
        Caption = 'Available';
    }
    value(1; "On Trip")
    {
        Caption = 'On Trip';
    }
    value(2; Maintenance)
    {
        Caption = 'Maintenance / Leave';
    }
    value(3; Inactive)
    {
        Caption = 'Inactive';
    }
}
