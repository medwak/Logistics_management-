pageextension 50100 "LMS Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("LMS Goods Type Code"; Rec."LMS Goods Type Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the logistics goods type of the item, which determines handling, temperature, dangerous goods and vehicle rules when it is shipped.';
            }
        }
    }
}
