pageextension 50102 "LMS Sales Order" extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            group(LMSLogistics)
            {
                Caption = 'Logistics';
                action(LMSCreateShipment)
                {
                    ApplicationArea = All;
                    Caption = 'Create Logistics Shipment';
                    Image = Shipment;
                    ToolTip = 'Create a logistics shipment with the outstanding item lines of this order.';

                    trigger OnAction()
                    var
                        ShipmentHeader: Record "LMS Shipment Header";
                        ShipmentMgt: Codeunit "LMS Shipment Mgt.";
                    begin
                        ShipmentHeader.Get(ShipmentMgt.CreateFromSalesOrder(Rec));
                        Page.Run(Page::"LMS Shipment Card", ShipmentHeader);
                    end;
                }
                action(LMSShowShipments)
                {
                    ApplicationArea = All;
                    Caption = 'Logistics Shipments';
                    Image = Shipment;
                    RunObject = page "LMS Shipments";
                    RunPageLink = "Source Document Type" = const("Sales Order"), "Source Document No." = field("No.");
                    ToolTip = 'View the logistics shipments created from this order.';
                }
            }
        }
    }
}
