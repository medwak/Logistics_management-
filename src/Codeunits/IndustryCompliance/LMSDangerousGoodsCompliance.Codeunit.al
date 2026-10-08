/// <summary>
/// Dangerous goods rules (ADR / IMDG / IATA style) for chemicals and oil &amp; gas:
/// complete hazard classification and a simplified segregation table for incompatible classes.
/// </summary>
codeunit 50123 "LMS Dangerous Goods Compliance" implements "LMS IIndustry Compliance"
{
    Access = Public;

    var
        RuleTxt: Label 'Dangerous Goods', Locked = true;
        HazardClassErr: Label 'Line %1 (%2): hazardous goods require a hazard class.', Comment = '%1 = line no., %2 = description';
        PackingGroupMsg: Label 'Line %1 (%2): no packing group specified.', Comment = '%1 = line no., %2 = description';
        SegregationErr: Label 'Hazard class %1 must not be loaded together with hazard class %2.', Comment = '%1 = class, %2 = class';
        ExplosivesErr: Label 'Explosives (class 1) must not be loaded together with any other goods.';

    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    var
        ShipmentLine: Record "LMS Shipment Line";
        Classes: List of [Text];
        MainClass: Text;
        HasNonExplosive: Boolean;
    begin
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter(Type, '<>%1', ShipmentLine.Type::" ");
        if ShipmentLine.FindSet() then
            repeat
                if ShipmentLine.Hazardous then begin
                    if ShipmentLine."Hazard Class" = '' then
                        TempComplianceIssue.AddError(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(HazardClassErr, ShipmentLine."Line No.", ShipmentLine.Description))
                    else begin
                        MainClass := GetMainClass(ShipmentLine."Hazard Class");
                        if not Classes.Contains(MainClass) then
                            Classes.Add(MainClass);
                        if MainClass <> '1' then
                            HasNonExplosive := true;
                    end;
                    if ShipmentLine."Packing Group" = '' then
                        TempComplianceIssue.AddWarning(ShipmentHeader."No.", ShipmentLine."Line No.", RuleTxt, StrSubstNo(PackingGroupMsg, ShipmentLine."Line No.", ShipmentLine.Description));
                end else
                    HasNonExplosive := true;
            until ShipmentLine.Next() = 0;

        if Classes.Contains('1') and HasNonExplosive then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, RuleTxt, ExplosivesErr);

        CheckPair(ShipmentHeader, Classes, '3', '5', TempComplianceIssue);  // flammable liquids vs. oxidizers
        CheckPair(ShipmentHeader, Classes, '4', '5', TempComplianceIssue);  // flammable solids vs. oxidizers
        CheckPair(ShipmentHeader, Classes, '2', '5', TempComplianceIssue);  // gases vs. oxidizers
        CheckPair(ShipmentHeader, Classes, '6', '3', TempComplianceIssue);  // toxics vs. flammable liquids
        CheckPair(ShipmentHeader, Classes, '7', '3', TempComplianceIssue);  // radioactive vs. flammable liquids
        CheckPair(ShipmentHeader, Classes, '8', '4', TempComplianceIssue);  // corrosives vs. flammable solids
    end;

    local procedure CheckPair(ShipmentHeader: Record "LMS Shipment Header"; Classes: List of [Text]; ClassA: Text; ClassB: Text; var TempComplianceIssue: Record "LMS Compliance Issue")
    begin
        if Classes.Contains(ClassA) and Classes.Contains(ClassB) then
            TempComplianceIssue.AddError(ShipmentHeader."No.", 0, RuleTxt, StrSubstNo(SegregationErr, ClassA, ClassB));
    end;

    local procedure GetMainClass(HazardClass: Code[10]): Text
    var
        DotPos: Integer;
    begin
        DotPos := StrPos(HazardClass, '.');
        if DotPos > 1 then
            exit(CopyStr(HazardClass, 1, DotPos - 1));
        exit(HazardClass);
    end;
}
