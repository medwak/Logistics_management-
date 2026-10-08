enum 50103 "LMS Shipment Status"
{
    Extensible = true;
    Caption = 'Shipment Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Released)
    {
        Caption = 'Released';
    }
    value(2; Planned)
    {
        Caption = 'Planned';
    }
    value(3; "Picked Up")
    {
        Caption = 'Picked Up';
    }
    value(4; "In Transit")
    {
        Caption = 'In Transit';
    }
    value(5; "At Hub")
    {
        Caption = 'At Hub';
    }
    value(6; "Out for Delivery")
    {
        Caption = 'Out for Delivery';
    }
    value(7; Delivered)
    {
        Caption = 'Delivered';
    }
    value(8; Exception)
    {
        Caption = 'Exception';
    }
    value(9; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
