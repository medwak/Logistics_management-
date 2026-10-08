tableextension 50100 "LMS Item" extends Item
{
    fields
    {
        field(50100; "LMS Goods Type Code"; Code[20])
        {
            Caption = 'Logistics Goods Type';
            DataClassification = CustomerContent;
            TableRelation = "LMS Goods Type";
        }
    }
}
