page 50111 "LMS Shipment Card"
{
    Caption = 'Logistics Shipment';
    PageType = Document;
    SourceTable = "LMS Shipment Header";
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsOpen;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the shipment number.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the customer that owns or receives the goods.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the customer name.';
                }
                field("Industry Code"; Rec."Industry Code")
                {
                    ToolTip = 'Specifies the industry profile that drives the compliance rules of this shipment.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Industry Type"; Rec."Industry Type")
                {
                    ToolTip = 'Specifies the industry type of the profile.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the date the goods are dispatched.';
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ToolTip = 'Specifies the promised delivery date.';
                }
                field("External Reference"; Rec."External Reference")
                {
                    ToolTip = 'Specifies the customer reference, such as a purchase order number.';
                }
                field("Source Document Type"; Rec."Source Document Type")
                {
                    ToolTip = 'Specifies the type of document the shipment was created from.';
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ToolTip = 'Specifies the document the shipment was created from.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the shipment.';
                    StyleExpr = StatusStyle;
                }
            }
            part(Lines; "LMS Shipment Subform")
            {
                Caption = 'Goods';
                SubPageLink = "Shipment No." = field("No.");
                UpdatePropagation = Both;
                Editable = IsOpen;
            }
            group(ShipTo)
            {
                Caption = 'Ship-from / Ship-to';
                Editable = IsOpen;
                field("Ship-from Location Code"; Rec."Ship-from Location Code")
                {
                    ToolTip = 'Specifies the warehouse or location the goods leave from.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the name of the consignee.';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the delivery address.';
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the city.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the post code.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region. A country other than the company''s makes the shipment cross-border.';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ToolTip = 'Specifies the contact person at the delivery address.';
                }
                field("Ship-to Phone No."; Rec."Ship-to Phone No.")
                {
                    ToolTip = 'Specifies the phone number of the contact.';
                }
                field("Special Instructions"; Rec."Special Instructions")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies handling or delivery instructions for the driver.';
                }
            }
            group(Transport)
            {
                Caption = 'Transport';
                field("Transport Mode"; Rec."Transport Mode")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies how the goods travel.';
                }
                field("Route Code"; Rec."Route Code")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the route, which supplies distance, transit time and rate zone.';
                }
                field("Distance (km)"; Rec."Distance (km)")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the distance.';
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    Editable = CanAssignResources;
                    ToolTip = 'Specifies the vehicle that carries the goods.';
                }
                field("Driver No."; Rec."Driver No.")
                {
                    Editable = CanAssignResources;
                    ToolTip = 'Specifies the driver.';
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ToolTip = 'Specifies the external carrier, if the shipment is subcontracted.';
                }
                field("Tracking No."; Rec."Tracking No.")
                {
                    ToolTip = 'Specifies the tracking number of the external carrier.';
                }
            }
            group(Handling)
            {
                Caption = 'Handling & Charges';
                field("Total Gross Weight (kg)"; Rec."Total Gross Weight (kg)")
                {
                    ToolTip = 'Specifies the total gross weight of the goods.';
                }
                field("Total Volume (m3)"; Rec."Total Volume (m3)")
                {
                    ToolTip = 'Specifies the total volume of the goods.';
                }
                field("Total Pallets"; Rec."Total Pallets")
                {
                    ToolTip = 'Specifies the total number of pallets.';
                }
                field("Total Declared Value"; Rec."Total Declared Value")
                {
                    ToolTip = 'Specifies the total declared value of the goods.';
                }
                field("Contains Hazardous Goods"; Rec."Contains Hazardous Goods")
                {
                    ToolTip = 'Specifies whether the shipment contains dangerous goods. Updated by the compliance check.';
                }
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the shipment must be temperature controlled. Updated by the compliance check.';
                }
                field("Required Min. Temp. (C)"; Rec."Required Min. Temp. (C)")
                {
                    ToolTip = 'Specifies the lowest allowed temperature for all goods on the shipment.';
                }
                field("Required Max. Temp. (C)"; Rec."Required Max. Temp. (C)")
                {
                    ToolTip = 'Specifies the highest allowed temperature for all goods on the shipment.';
                }
                field("Freight Charge"; Rec."Freight Charge")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the freight charge.';
                }
                field("Surcharge Amount"; Rec."Surcharge Amount")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the handling surcharge for special goods.';
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {
                    Editable = IsOpen;
                    ToolTip = 'Specifies the cargo insurance premium.';
                }
                field("Total Charge"; Rec."Total Charge")
                {
                    Style = Strong;
                    ToolTip = 'Specifies the total charge.';
                }
            }
            part(Documents; "LMS Shipment Documents")
            {
                Caption = 'Required Documents';
                SubPageLink = "Shipment No." = field("No.");
            }
            group(Delivery)
            {
                Caption = 'Tracking & Delivery';
                field("Last Known Location"; Rec."Last Known Location")
                {
                    ToolTip = 'Specifies the last reported location.';
                }
                field("Last Status Update"; Rec."Last Status Update")
                {
                    ToolTip = 'Specifies when the status was last updated.';
                }
                field("Actual Pickup DateTime"; Rec."Actual Pickup DateTime")
                {
                    ToolTip = 'Specifies when the goods were picked up.';
                }
                field("Actual Delivery DateTime"; Rec."Actual Delivery DateTime")
                {
                    ToolTip = 'Specifies when the goods were delivered.';
                }
                field("POD Received By"; Rec."POD Received By")
                {
                    ToolTip = 'Specifies who signed for the goods.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ReleaseGroup)
            {
                Caption = 'Release';
                action(Release)
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Run the compliance checks, calculate the charges and release the shipment for planning.';

                    trigger OnAction()
                    begin
                        ShipmentMgt.Release(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ToolTip = 'Reopen the shipment to change it.';

                    trigger OnAction()
                    begin
                        ShipmentMgt.Reopen(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            action(CheckCompliance)
            {
                Caption = 'Check Compliance';
                Image = CheckList;
                ToolTip = 'Check the shipment against the rules of its industry, goods, vehicle and driver without releasing it.';

                trigger OnAction()
                begin
                    ShipmentMgt.CheckCompliance(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(RefreshDocuments)
            {
                Caption = 'Refresh Required Documents';
                Image = Refresh;
                ToolTip = 'Rebuild the required documents list from the industry profile and the goods on the shipment.';

                trigger OnAction()
                var
                    ComplianceMgt: Codeunit "LMS Compliance Mgt.";
                begin
                    ComplianceMgt.RefreshRequiredDocuments(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CalculateCharges)
            {
                Caption = 'Calculate Charges';
                Image = Calculate;
                ToolTip = 'Calculate freight, handling surcharge and insurance from the freight rates and goods types.';

                trigger OnAction()
                var
                    FreightCalcMgt: Codeunit "LMS Freight Calc. Mgt.";
                begin
                    Rec.TestStatusOpen();
                    FreightCalcMgt.CalculateCharges(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Plan)
            {
                Caption = 'Plan / Assign Resources';
                Image = Resource;
                ToolTip = 'Confirm the vehicle and driver for the shipment after validating them against the goods.';

                trigger OnAction()
                begin
                    ShipmentMgt.Plan(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(UpdateStatus)
            {
                Caption = 'Update Status';
                Image = Status;
                ToolTip = 'Record pickup, transit, hub, delivery or an exception and add it to the tracking history.';

                trigger OnAction()
                var
                    UpdateStatusDialog: Page "LMS Update Status Dialog";
                begin
                    UpdateStatusDialog.SetShipment(Rec);
                    if UpdateStatusDialog.RunModal() = Action::OK then begin
                        ShipmentMgt.SetStatus(Rec, UpdateStatusDialog.GetNewStatus(), UpdateStatusDialog.GetLocation(),
                            UpdateStatusDialog.GetDescription(), UpdateStatusDialog.GetReceivedBy());
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(CancelShipment)
            {
                Caption = 'Cancel Shipment';
                Image = Cancel;
                ToolTip = 'Cancel the shipment and release its vehicle and driver.';

                trigger OnAction()
                begin
                    if Confirm(CancelQst, false, Rec."No.") then begin
                        ShipmentMgt.SetStatus(Rec, Rec.Status::Cancelled, '', CancelledTxt, '');
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action(TrackingEntries)
            {
                Caption = 'Tracking History';
                Image = Navigate;
                RunObject = page "LMS Tracking Entries";
                RunPageLink = "Shipment No." = field("No.");
                ToolTip = 'View all tracking events of the shipment.';
            }
            action(CustomerCard)
            {
                Caption = 'Customer';
                Image = Customer;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
                ToolTip = 'Open the customer card.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
                actionref(CheckCompliance_Promoted; CheckCompliance)
                {
                }
                actionref(Plan_Promoted; Plan)
                {
                }
                actionref(UpdateStatus_Promoted; UpdateStatus)
                {
                }
            }
            group(Category_Charges)
            {
                Caption = 'Charges & Documents';
                actionref(CalculateCharges_Promoted; CalculateCharges)
                {
                }
                actionref(RefreshDocuments_Promoted; RefreshDocuments)
                {
                }
            }
            actionref(TrackingEntries_Promoted; TrackingEntries)
            {
            }
        }
    }

    var
        ShipmentMgt: Codeunit "LMS Shipment Mgt.";
        IsOpen: Boolean;
        CanAssignResources: Boolean;
        StatusStyle: Text;
        CancelQst: Label 'Do you want to cancel shipment %1?', Comment = '%1 = shipment no.';
        CancelledTxt: Label 'Shipment cancelled.';

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
        CanAssignResources := Rec.Status in [Rec.Status::Open, Rec.Status::Released, Rec.Status::Planned];
        StatusStyle := Rec.GetStatusStyle();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsOpen := true;
        CanAssignResources := true;
    end;
}
