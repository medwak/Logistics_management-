tableextension 50101 "LMS Customer" extends Customer
{
    fields
    {
        field(50100; "LMS Industry Code"; Code[20])
        {
            Caption = 'Logistics Industry Profile';
            DataClassification = CustomerContent;
            TableRelation = "LMS Industry Profile";
        }
    }
}
