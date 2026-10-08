enum 50107 "LMS Shipment Line Type"
{
    Extensible = true;
    Caption = 'Shipment Line Type';

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Item)
    {
        Caption = 'Item';
    }
    value(2; "Customer Goods")
    {
        Caption = 'Customer Goods (3PL)';
    }
}
