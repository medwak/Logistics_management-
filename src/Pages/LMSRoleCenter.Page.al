page 50116 "LMS Role Center"
{
    Caption = 'Logistics Manager';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(RoleCenter)
        {
            part(Activities; "LMS Activities")
            {
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(Shipments)
            {
                Caption = 'Shipments';
                RunObject = page "LMS Shipments";
                ToolTip = 'Open the list of logistics shipments.';
            }
            action(Vehicles)
            {
                Caption = 'Vehicles';
                RunObject = page "LMS Vehicles";
                ToolTip = 'Open the fleet.';
            }
            action(Drivers)
            {
                Caption = 'Drivers';
                RunObject = page "LMS Drivers";
                ToolTip = 'Open the drivers.';
            }
            action(Routes)
            {
                Caption = 'Routes';
                RunObject = page "LMS Routes";
                ToolTip = 'Open the routes.';
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = page "Customer List";
                ToolTip = 'Open the customers.';
            }
            action(Items)
            {
                Caption = 'Items';
                RunObject = page "Item List";
                ToolTip = 'Open the items.';
            }
        }
        area(Sections)
        {
            group(ShipmentsByStatus)
            {
                Caption = 'Shipments';
                action(OpenShipments)
                {
                    Caption = 'Open';
                    RunObject = page "LMS Shipments";
                    RunPageView = where(Status = const(Open));
                    ToolTip = 'Shipments being prepared.';
                }
                action(InTransitShipments)
                {
                    Caption = 'In Transit';
                    RunObject = page "LMS Shipments";
                    RunPageView = where(Status = filter("Picked Up" | "In Transit" | "At Hub" | "Out for Delivery"));
                    ToolTip = 'Shipments on the road, in the air or at sea.';
                }
                action(ExceptionShipments)
                {
                    Caption = 'Exceptions';
                    RunObject = page "LMS Shipments";
                    RunPageView = where(Status = const(Exception));
                    ToolTip = 'Shipments with delivery problems.';
                }
                action(TrackingHistory)
                {
                    Caption = 'Tracking History';
                    RunObject = page "LMS Tracking Entries";
                    ToolTip = 'All tracking events.';
                }
            }
            group(Configuration)
            {
                Caption = 'Setup';
                action(Setup)
                {
                    Caption = 'Logistics Setup';
                    RunObject = page "LMS Setup";
                    ToolTip = 'Configure the logistics module.';
                }
                action(IndustryProfiles)
                {
                    Caption = 'Industry Profiles';
                    RunObject = page "LMS Industry Profiles";
                    ToolTip = 'Configure the industries you serve.';
                }
                action(RequiredDocuments)
                {
                    Caption = 'Required Documents';
                    RunObject = page "LMS Industry Documents";
                    ToolTip = 'Configure the documents each industry requires.';
                }
                action(GoodsTypes)
                {
                    Caption = 'Goods Types';
                    RunObject = page "LMS Goods Types";
                    ToolTip = 'Configure the types of goods you handle.';
                }
                action(FreightRates)
                {
                    Caption = 'Freight Rates';
                    RunObject = page "LMS Freight Rates";
                    ToolTip = 'Configure the freight tariffs.';
                }
            }
        }
        area(Creation)
        {
            action(NewShipment)
            {
                Caption = 'Shipment';
                RunObject = page "LMS Shipment Card";
                RunPageMode = Create;
                ToolTip = 'Create a new logistics shipment.';
            }
            action(NewVehicle)
            {
                Caption = 'Vehicle';
                RunObject = page "LMS Vehicle Card";
                RunPageMode = Create;
                ToolTip = 'Register a new vehicle.';
            }
        }
    }
}
