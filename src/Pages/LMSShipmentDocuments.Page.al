page 50113 "LMS Shipment Documents"
{
    Caption = 'Required Documents';
    PageType = ListPart;
    SourceTable = "LMS Shipment Document";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Document Code"; Rec."Document Code")
                {
                    ToolTip = 'Specifies the document code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the document.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ToolTip = 'Specifies whether the shipment cannot be released until the document is received.';
                }
                field(Received; Rec.Received)
                {
                    ToolTip = 'Specifies whether the document has been received or attached.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the reference number of the document, for example a certificate number.';
                }
                field("Received Date"; Rec."Received Date")
                {
                    ToolTip = 'Specifies when the document was received.';
                }
                field("Received By"; Rec."Received By")
                {
                    ToolTip = 'Specifies who registered the document.';
                }
            }
        }
    }
}
