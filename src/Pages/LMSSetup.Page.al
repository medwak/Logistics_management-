page 50100 "LMS Setup"
{
    Caption = 'Logistics Setup';
    PageType = Card;
    SourceTable = "LMS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Shipment Nos."; Rec."Shipment Nos.")
                {
                    ToolTip = 'Specifies the number series used for logistics shipments.';
                }
            }
            group(Defaults)
            {
                Caption = 'Defaults';
                field("Default Industry Code"; Rec."Default Industry Code")
                {
                    ToolTip = 'Specifies the industry profile used for shipments whose customer has no industry profile.';
                }
                field("Default Transport Mode"; Rec."Default Transport Mode")
                {
                    ToolTip = 'Specifies the transport mode used when no industry profile is set.';
                }
                field("Volumetric Factor (kg/m3)"; Rec."Volumetric Factor (kg/m3)")
                {
                    ToolTip = 'Specifies the kg per cubic meter used to calculate volumetric weight when the freight rate has no own factor.';
                }
            }
            group(Compliance)
            {
                Caption = 'Compliance & Charges';
                field("Block Release on Warnings"; Rec."Block Release on Warnings")
                {
                    ToolTip = 'Specifies whether shipments with compliance warnings (not only errors) are blocked from release.';
                }
                field("Auto-Calc. Charges on Release"; Rec."Auto-Calc. Charges on Release")
                {
                    ToolTip = 'Specifies whether freight, surcharges and insurance are calculated automatically when a shipment is released.';
                }
                field("Expiry Warning Days"; Rec."Expiry Warning Days")
                {
                    ToolTip = 'Specifies how many days before expiry of goods, licenses and certificates a warning is raised.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadDefaults)
            {
                Caption = 'Load Default Industry Data';
                ToolTip = 'Creates the default industry profiles, goods types, required documents and freight rates. Existing records are not changed.';
                Image = Setup;

                trigger OnAction()
                var
                    SetupData: Codeunit "LMS Setup Data";
                begin
                    SetupData.InsertDefaults();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(IndustryProfiles)
            {
                Caption = 'Industry Profiles';
                Image = SetupList;
                RunObject = page "LMS Industry Profiles";
                ToolTip = 'Open the industry profiles.';
            }
            action(GoodsTypes)
            {
                Caption = 'Goods Types';
                Image = Category;
                RunObject = page "LMS Goods Types";
                ToolTip = 'Open the goods types.';
            }
            action(FreightRates)
            {
                Caption = 'Freight Rates';
                Image = Price;
                RunObject = page "LMS Freight Rates";
                ToolTip = 'Open the freight rates.';
            }
        }
        area(Promoted)
        {
            actionref(LoadDefaults_Promoted; LoadDefaults)
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
