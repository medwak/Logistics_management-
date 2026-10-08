page 50112 "LMS Shipment Subform"
{
    Caption = 'Goods';
    PageType = ListPart;
    SourceTable = "LMS Shipment Line";
    ApplicationArea = All;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies whether the line is a company item or third-party customer goods.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the item number, or the customer''s own article number for customer goods.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the goods.';
                }
                field("Goods Type Code"; Rec."Goods Type Code")
                {
                    ToolTip = 'Specifies the goods type, which determines handling, temperature, dangerous goods and vehicle rules.';
                }
                field("Handling Class"; Rec."Handling Class")
                {
                    Editable = false;
                    ToolTip = 'Specifies the handling class of the goods type.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the unit of measure.';
                }
                field("Unit Weight (kg)"; Rec."Unit Weight (kg)")
                {
                    ToolTip = 'Specifies the gross weight per unit.';
                }
                field("Unit Volume (m3)"; Rec."Unit Volume (m3)")
                {
                    ToolTip = 'Specifies the volume per unit.';
                }
                field("Gross Weight (kg)"; Rec."Gross Weight (kg)")
                {
                    ToolTip = 'Specifies the total gross weight of the line.';
                }
                field("Volume (m3)"; Rec."Volume (m3)")
                {
                    ToolTip = 'Specifies the total volume of the line.';
                }
                field("No. of Pallets"; Rec."No. of Pallets")
                {
                    ToolTip = 'Specifies the number of pallets.';
                }
                field("No. of Packages"; Rec."No. of Packages")
                {
                    ToolTip = 'Specifies the number of packages.';
                }
                field("Declared Unit Value"; Rec."Declared Unit Value")
                {
                    ToolTip = 'Specifies the declared value per unit.';
                }
                field("Declared Value"; Rec."Declared Value")
                {
                    ToolTip = 'Specifies the declared value of the line.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the lot or batch number.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the serial number.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the expiration date of the goods.';
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ToolTip = 'Specifies the HS tariff number for customs.';
                }
                field("Country of Origin Code"; Rec."Country of Origin Code")
                {
                    ToolTip = 'Specifies the country of origin for customs.';
                }
                field("Temperature Controlled"; Rec."Temperature Controlled")
                {
                    ToolTip = 'Specifies whether the goods must be temperature controlled.';
                }
                field("Min. Temperature (C)"; Rec."Min. Temperature (C)")
                {
                    ToolTip = 'Specifies the minimum temperature.';
                }
                field("Max. Temperature (C)"; Rec."Max. Temperature (C)")
                {
                    ToolTip = 'Specifies the maximum temperature.';
                }
                field(Hazardous; Rec.Hazardous)
                {
                    ToolTip = 'Specifies whether the goods are dangerous goods.';
                }
                field("UN Number"; Rec."UN Number")
                {
                    ToolTip = 'Specifies the UN number.';
                }
                field("Hazard Class"; Rec."Hazard Class")
                {
                    ToolTip = 'Specifies the hazard class.';
                }
                field("Packing Group"; Rec."Packing Group")
                {
                    ToolTip = 'Specifies the packing group.';
                }
            }
        }
    }
}
