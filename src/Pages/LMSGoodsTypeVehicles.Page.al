page 50104 "LMS Goods Type Vehicles"
{
    Caption = 'Allowed Vehicle Types';
    PageType = List;
    SourceTable = "LMS Goods Type Vehicle";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Goods Type Code"; Rec."Goods Type Code")
                {
                    ToolTip = 'Specifies the goods type.';
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ToolTip = 'Specifies a vehicle type allowed to carry the goods type.';
                }
            }
        }
    }
}
