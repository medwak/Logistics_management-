table 50114 "LMS Compliance Issue"
{
    Caption = 'Shipment Compliance Issue';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Severity; Enum "LMS Issue Severity")
        {
            Caption = 'Severity';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Rule Source"; Text[50])
        {
            Caption = 'Rule Source';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure AddError(ShipmentNo: Code[20]; LineNo: Integer; RuleSource: Text; IssueText: Text)
    begin
        AddIssue(ShipmentNo, LineNo, Severity::Error, RuleSource, IssueText);
    end;

    procedure AddWarning(ShipmentNo: Code[20]; LineNo: Integer; RuleSource: Text; IssueText: Text)
    begin
        AddIssue(ShipmentNo, LineNo, Severity::Warning, RuleSource, IssueText);
    end;

    procedure AddIssue(ShipmentNo: Code[20]; LineNo: Integer; NewSeverity: Enum "LMS Issue Severity"; RuleSource: Text; IssueText: Text)
    var
        NextEntryNo: Integer;
    begin
        Rec.Reset();
        if Rec.FindLast() then
            NextEntryNo := Rec."Entry No." + 1
        else
            NextEntryNo := 1;
        Rec.Init();
        Rec."Entry No." := NextEntryNo;
        Rec."Shipment No." := ShipmentNo;
        Rec."Line No." := LineNo;
        Rec.Severity := NewSeverity;
        Rec."Rule Source" := CopyStr(RuleSource, 1, MaxStrLen(Rec."Rule Source"));
        Rec.Description := CopyStr(IssueText, 1, MaxStrLen(Rec.Description));
        Rec.Insert();
    end;

    procedure HasErrors(): Boolean
    var
        Result: Boolean;
    begin
        Rec.Reset();
        Rec.SetRange(Severity, Severity::Error);
        Result := not Rec.IsEmpty();
        Rec.Reset();
        exit(Result);
    end;
}
