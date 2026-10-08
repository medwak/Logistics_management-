codeunit 50104 "LMS Freight Calc. Mgt."
{
    var
        NoRateFoundMsg: Label 'No freight rate was found for transport mode %1. Freight charge is set to zero.', Comment = '%1 = transport mode';

    procedure CalculateCharges(var ShipmentHeader: Record "LMS Shipment Header")
    var
        FreightRate: Record "LMS Freight Rate";
        RateCalculator: Interface "LMS IFreight Rate Calculator";
        FreightAmount: Decimal;
        RateFound: Boolean;
    begin
        ShipmentHeader.CalcFields("Total Gross Weight (kg)", "Total Volume (m3)", "Total Pallets", "Total Declared Value");

        RateFound := FindFreightRate(ShipmentHeader, FreightRate);
        if RateFound then begin
            RateCalculator := FreightRate."Rate Basis";
            FreightAmount := RateCalculator.CalculateCharge(FreightRate, ShipmentHeader);
            if FreightAmount < FreightRate."Minimum Charge" then
                FreightAmount := FreightRate."Minimum Charge";
            ShipmentHeader."Applied Freight Rate No." := FreightRate."Entry No.";
        end else begin
            ShipmentHeader."Applied Freight Rate No." := 0;
            if GuiAllowed() then
                Message(NoRateFoundMsg, ShipmentHeader."Transport Mode");
        end;

        OnAfterCalculateFreightAmount(ShipmentHeader, FreightRate, RateFound, FreightAmount);

        ShipmentHeader."Freight Charge" := Round(FreightAmount);
        ShipmentHeader."Surcharge Amount" := Round(FreightAmount * GetMaxHandlingSurchargePct(ShipmentHeader."No.") / 100);
        ShipmentHeader."Insurance Amount" := Round(CalcInsuranceAmount(ShipmentHeader));
        ShipmentHeader."Total Charge" := ShipmentHeader."Freight Charge" + ShipmentHeader."Surcharge Amount" + ShipmentHeader."Insurance Amount";
        ShipmentHeader.Modify(true);
    end;

    procedure FindFreightRate(ShipmentHeader: Record "LMS Shipment Header"; var FreightRate: Record "LMS Freight Rate"): Boolean
    var
        Route: Record "LMS Route";
        GoodsTypeCode: Code[20];
        ZoneCode: Code[10];
        Handled: Boolean;
    begin
        OnBeforeFindFreightRate(ShipmentHeader, FreightRate, Handled);
        if Handled then
            exit(FreightRate."Entry No." <> 0);

        GoodsTypeCode := GetDominantGoodsType(ShipmentHeader."No.");
        if Route.Get(ShipmentHeader."Route Code") then
            ZoneCode := Route."Zone Code";

        if FindRate(ShipmentHeader, GoodsTypeCode, ZoneCode, FreightRate) then
            exit(true);
        if FindRate(ShipmentHeader, GoodsTypeCode, '', FreightRate) then
            exit(true);
        if FindRate(ShipmentHeader, '', ZoneCode, FreightRate) then
            exit(true);
        exit(FindRate(ShipmentHeader, '', '', FreightRate));
    end;

    /// <summary>The goods type of the heaviest line drives the tariff on mixed loads.</summary>
    procedure GetDominantGoodsType(ShipmentNo: Code[20]): Code[20]
    var
        ShipmentLine: Record "LMS Shipment Line";
        MaxWeight: Decimal;
        GoodsTypeCode: Code[20];
    begin
        MaxWeight := -1;
        ShipmentLine.SetRange("Shipment No.", ShipmentNo);
        ShipmentLine.SetFilter("Goods Type Code", '<>%1', '');
        if ShipmentLine.FindSet() then
            repeat
                if ShipmentLine."Gross Weight (kg)" > MaxWeight then begin
                    MaxWeight := ShipmentLine."Gross Weight (kg)";
                    GoodsTypeCode := ShipmentLine."Goods Type Code";
                end;
            until ShipmentLine.Next() = 0;
        exit(GoodsTypeCode);
    end;

    local procedure FindRate(ShipmentHeader: Record "LMS Shipment Header"; GoodsTypeCode: Code[20]; ZoneCode: Code[10]; var FreightRate: Record "LMS Freight Rate"): Boolean
    var
        RateDate: Date;
    begin
        RateDate := ShipmentHeader."Shipment Date";
        if RateDate = 0D then
            RateDate := WorkDate();

        FreightRate.Reset();
        FreightRate.SetCurrentKey("Transport Mode", "Goods Type Code", "Zone Code", "Starting Date", "Minimum Weight (kg)");
        FreightRate.SetRange("Transport Mode", ShipmentHeader."Transport Mode");
        FreightRate.SetRange("Goods Type Code", GoodsTypeCode);
        FreightRate.SetRange("Zone Code", ZoneCode);
        FreightRate.SetFilter("Starting Date", '..%1', RateDate);
        FreightRate.SetFilter("Minimum Weight (kg)", '..%1', ShipmentHeader."Total Gross Weight (kg)");
        exit(FreightRate.FindLast());
    end;

    local procedure GetMaxHandlingSurchargePct(ShipmentNo: Code[20]): Decimal
    var
        ShipmentLine: Record "LMS Shipment Line";
        GoodsType: Record "LMS Goods Type";
        MaxPct: Decimal;
    begin
        MaxPct := 0;
        ShipmentLine.SetRange("Shipment No.", ShipmentNo);
        ShipmentLine.SetFilter("Goods Type Code", '<>%1', '');
        if ShipmentLine.FindSet() then
            repeat
                if GoodsType.Get(ShipmentLine."Goods Type Code") then
                    if GoodsType."Handling Surcharge %" > MaxPct then
                        MaxPct := GoodsType."Handling Surcharge %";
            until ShipmentLine.Next() = 0;
        exit(MaxPct);
    end;

    local procedure CalcInsuranceAmount(ShipmentHeader: Record "LMS Shipment Header") Amount: Decimal
    var
        ShipmentLine: Record "LMS Shipment Line";
        GoodsType: Record "LMS Goods Type";
    begin
        ShipmentLine.SetRange("Shipment No.", ShipmentHeader."No.");
        ShipmentLine.SetFilter("Goods Type Code", '<>%1', '');
        if ShipmentLine.FindSet() then
            repeat
                if GoodsType.Get(ShipmentLine."Goods Type Code") then
                    Amount += ShipmentLine."Declared Value" * GoodsType."Insurance Rate %" / 100;
            until ShipmentLine.Next() = 0;
        OnAfterCalcInsuranceAmount(ShipmentHeader, Amount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindFreightRate(ShipmentHeader: Record "LMS Shipment Header"; var FreightRate: Record "LMS Freight Rate"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateFreightAmount(var ShipmentHeader: Record "LMS Shipment Header"; FreightRate: Record "LMS Freight Rate"; RateFound: Boolean; var FreightAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcInsuranceAmount(ShipmentHeader: Record "LMS Shipment Header"; var Amount: Decimal)
    begin
    end;
}
