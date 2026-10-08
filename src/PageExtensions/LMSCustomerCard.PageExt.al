pageextension 50101 "LMS Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("LMS Industry Code"; Rec."LMS Industry Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the industry profile applied to logistics shipments for this customer.';
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(LMSShipments)
            {
                ApplicationArea = All;
                Caption = 'Logistics Shipments';
                Image = Shipment;
                RunObject = page "LMS Shipments";
                RunPageLink = "Customer No." = field("No.");
                ToolTip = 'View the logistics shipments for this customer.';
            }
        }
    }
}
