page 50102 "LMS Industry Documents"
{
    Caption = 'Industry Required Documents';
    PageType = List;
    SourceTable = "LMS Industry Document";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Industry Code"; Rec."Industry Code")
                {
                    ToolTip = 'Specifies the industry profile. Leave blank to require the document for all industries.';
                }
                field("Document Code"; Rec."Document Code")
                {
                    ToolTip = 'Specifies the document code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the document description.';
                }
                field(Condition; Rec.Condition)
                {
                    ToolTip = 'Specifies when the document is required.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ToolTip = 'Specifies whether the shipment cannot be released until the document is received.';
                }
            }
        }
    }
}
