page 50115 "LMS Compliance Issues"
{
    Caption = 'Shipment Compliance Issues';
    PageType = List;
    SourceTable = "LMS Compliance Issue";
    SourceTableTemporary = true;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Severity; Rec.Severity)
                {
                    StyleExpr = SeverityStyle;
                    ToolTip = 'Specifies whether the issue blocks the release (error) or not (warning).';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the issue.';
                }
                field("Line No."; Rec."Line No.")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the shipment line the issue concerns.';
                }
                field("Rule Source"; Rec."Rule Source")
                {
                    ToolTip = 'Specifies which rule set raised the issue.';
                }
            }
        }
    }

    var
        SeverityStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Severity = Rec.Severity::Error then
            SeverityStyle := 'Unfavorable'
        else
            SeverityStyle := 'Ambiguous';
    end;

    procedure SetIssues(var TempComplianceIssue: Record "LMS Compliance Issue")
    begin
        Rec.Reset();
        Rec.DeleteAll();
        TempComplianceIssue.Reset();
        if TempComplianceIssue.FindSet() then
            repeat
                Rec := TempComplianceIssue;
                Rec.Insert();
            until TempComplianceIssue.Next() = 0;
        if Rec.FindFirst() then;
    end;
}
