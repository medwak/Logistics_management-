page 50101 "LMS Industry Profiles"
{
    Caption = 'Industry Profiles';
    PageType = List;
    SourceTable = "LMS Industry Profile";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the code of the industry profile.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description.';
                }
                field("Industry Type"; Rec."Industry Type")
                {
                    ToolTip = 'Specifies the industry type, which determines the industry-specific compliance rules.';
                }
                field("Default Transport Mode"; Rec."Default Transport Mode")
                {
                    ToolTip = 'Specifies the default transport mode for shipments of this industry.';
                }
                field("Default Goods Type Code"; Rec."Default Goods Type Code")
                {
                    ToolTip = 'Specifies the goods type proposed on shipment lines when the item has none.';
                }
                field("Requires Lot Tracking"; Rec."Requires Lot Tracking")
                {
                    ToolTip = 'Specifies whether every shipment line must carry a lot/batch number.';
                }
                field("Requires Serial Tracking"; Rec."Requires Serial Tracking")
                {
                    ToolTip = 'Specifies whether every shipment line must carry a serial number.';
                }
                field("Requires Temp. Control"; Rec."Requires Temp. Control")
                {
                    ToolTip = 'Specifies whether shipments must be temperature controlled.';
                }
                field("Requires Hazmat Handling"; Rec."Requires Hazmat Handling")
                {
                    ToolTip = 'Specifies whether the industry typically ships dangerous goods.';
                }
                field("Requires Customs Data"; Rec."Requires Customs Data")
                {
                    ToolTip = 'Specifies whether HS tariff numbers are required on cross-border shipments.';
                }
                field("Requires Proof of Delivery"; Rec."Requires Proof of Delivery")
                {
                    ToolTip = 'Specifies whether the name of the recipient must be captured on delivery.';
                }
                field("Requires Insurance"; Rec."Requires Insurance")
                {
                    ToolTip = 'Specifies whether cargo insurance must be calculated.';
                }
                field("Max. Transit Hours"; Rec."Max. Transit Hours")
                {
                    ToolTip = 'Specifies the maximum acceptable transit time. Zero means no limit.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(RequiredDocuments)
            {
                Caption = 'Required Documents';
                Image = Documents;
                RunObject = page "LMS Industry Documents";
                RunPageLink = "Industry Code" = field("Code");
                ToolTip = 'Define the documents that shipments of this industry require.';
            }
        }
        area(Promoted)
        {
            actionref(RequiredDocuments_Promoted; RequiredDocuments)
            {
            }
        }
    }
}
