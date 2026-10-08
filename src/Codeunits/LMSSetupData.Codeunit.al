/// <summary>
/// Default configuration covering many industries and goods types. Safe to run repeatedly:
/// existing records are never overwritten.
/// </summary>
codeunit 50101 "LMS Setup Data"
{
    var
        ShipmentNosTok: Label 'LMS-SHIP', Locked = true;
        ShipmentNosDescTxt: Label 'Logistics Shipments';
        GeneralTok: Label 'GENERAL', Locked = true;

    procedure InsertDefaults()
    begin
        InsertNoSeries();
        InsertGoodsTypes();
        InsertGoodsTypeVehicles();
        InsertIndustryProfiles();
        InsertIndustryDocuments();
        InsertFreightRates();
        InsertSetup();
    end;

    local procedure InsertSetup()
    var
        LMSSetup: Record "LMS Setup";
    begin
        if not LMSSetup.Get() then begin
            LMSSetup.Init();
            LMSSetup.Insert();
        end;
        if LMSSetup."Shipment Nos." = '' then
            LMSSetup."Shipment Nos." := ShipmentNosTok;
        if LMSSetup."Default Industry Code" = '' then
            LMSSetup."Default Industry Code" := GeneralTok;
        LMSSetup.Modify();
    end;

    local procedure InsertNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(ShipmentNosTok) then
            exit;
        NoSeries.Init();
        NoSeries.Code := ShipmentNosTok;
        NoSeries.Description := ShipmentNosDescTxt;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := false;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := ShipmentNosTok;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := 'SHP000001';
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert();
    end;

    local procedure InsertGoodsTypes()
    var
        HC: Enum "LMS Handling Class";
    begin
        // Code, Description, Handling class, Temp controlled, Min, Max, Hazardous, UN, Class, PG, Stackable, Min shelf life, Surcharge %, Insurance %
        AddGoodsType('GENERAL', 'General cargo', HC::Standard, false, 0, 0, false, '', '', '', true, 0, 0, 0.1);
        AddGoodsType('FRAGILE', 'Fragile goods (glass, ceramics)', HC::Fragile, false, 0, 0, false, '', '', '', false, 0, 15, 0.3);
        AddGoodsType('AMBIENT-FOOD', 'Ambient food & beverages', HC::Standard, true, 5, 25, false, '', '', '', true, 7, 0, 0.1);
        AddGoodsType('CHILLED', 'Chilled perishables (dairy, meat, produce)', HC::Perishable, true, 0, 5, false, '', '', '', true, 3, 20, 0.2);
        AddGoodsType('FROZEN', 'Frozen goods', HC::Frozen, true, -25, -18, false, '', '', '', true, 30, 25, 0.2);
        AddGoodsType('PHARMA-CRT', 'Pharmaceuticals - controlled room temp.', HC::Standard, true, 15, 25, false, '', '', '', true, 90, 10, 0.5);
        AddGoodsType('PHARMA-COLD', 'Pharmaceuticals / vaccines - cold chain', HC::Perishable, true, 2, 8, false, '', '', '', true, 90, 30, 0.75);
        AddGoodsType('FLAMMABLE-LIQ', 'Flammable liquids (fuels, solvents, paints)', HC::Hazardous, false, 0, 0, true, 'UN1993', '3', 'II', true, 0, 35, 0.5);
        AddGoodsType('FUEL-BULK', 'Petroleum products in bulk', HC::"Bulk Liquid", false, 0, 0, true, 'UN1202', '3', 'III', false, 0, 30, 0.5);
        AddGoodsType('CORROSIVE', 'Corrosive substances (acids, alkalis)', HC::Hazardous, false, 0, 0, true, 'UN1760', '8', 'II', true, 0, 35, 0.5);
        AddGoodsType('OXIDIZER', 'Oxidizing substances (fertiliser grade AN, peroxides)', HC::Hazardous, false, 0, 0, true, 'UN1942', '5.1', 'III', true, 0, 35, 0.5);
        AddGoodsType('GAS', 'Compressed / liquefied gases (LPG)', HC::Hazardous, false, 0, 0, true, 'UN1075', '2.1', '', false, 0, 40, 0.6);
        AddGoodsType('BULK-LIQUID', 'Non-hazardous bulk liquids (water, edible oil)', HC::"Bulk Liquid", false, 0, 0, false, '', '', '', false, 0, 10, 0.1);
        AddGoodsType('BULK-DRY', 'Bulk dry (grain, cement, ore, aggregates)', HC::"Bulk Dry", false, 0, 0, false, '', '', '', false, 0, 5, 0.05);
        AddGoodsType('BUILDING-MAT', 'Building materials (steel, timber, blocks)', HC::Standard, false, 0, 0, false, '', '', '', true, 0, 5, 0.1);
        AddGoodsType('OVERSIZED', 'Oversized / heavy machinery', HC::Oversized, false, 0, 0, false, '', '', '', false, 0, 50, 0.4);
        AddGoodsType('ELECTRONICS', 'Consumer electronics & IT equipment', HC::"High Value", false, 0, 0, false, '', '', '', true, 0, 10, 1);
        AddGoodsType('AUTO-PARTS', 'Automotive spare parts', HC::Standard, false, 0, 0, false, '', '', '', true, 0, 0, 0.3);
        AddGoodsType('VEHICLES', 'Finished vehicles', HC::"High Value", false, 0, 0, false, '', '', '', false, 0, 20, 0.8);
        AddGoodsType('TEXTILES', 'Textiles, garments & footwear', HC::Standard, false, 0, 0, false, '', '', '', true, 0, 0, 0.1);
        AddGoodsType('LIVESTOCK', 'Live animals', HC::"Live Animals", false, 0, 0, false, '', '', '', false, 0, 40, 1);
        AddGoodsType('FRESH-PRODUCE', 'Fresh produce & flowers', HC::Perishable, true, 2, 12, false, '', '', '', true, 2, 15, 0.2);
        AddGoodsType('PARCEL', 'E-commerce parcels', HC::Standard, false, 0, 0, false, '', '', '', true, 0, 0, 0.1);
    end;

    local procedure InsertGoodsTypeVehicles()
    var
        VT: Enum "LMS Vehicle Type";
    begin
        AllowVehicle('CHILLED', VT::"Reefer Truck");
        AllowVehicle('CHILLED', VT::Aircraft);
        AllowVehicle('CHILLED', VT::Vessel);
        AllowVehicle('FROZEN', VT::"Reefer Truck");
        AllowVehicle('FROZEN', VT::Vessel);
        AllowVehicle('PHARMA-COLD', VT::"Reefer Truck");
        AllowVehicle('PHARMA-COLD', VT::Van);
        AllowVehicle('PHARMA-COLD', VT::Aircraft);
        AllowVehicle('FRESH-PRODUCE', VT::"Reefer Truck");
        AllowVehicle('FRESH-PRODUCE', VT::Aircraft);
        AllowVehicle('FUEL-BULK', VT::Tanker);
        AllowVehicle('FUEL-BULK', VT::"Rail Wagon");
        AllowVehicle('FUEL-BULK', VT::Vessel);
        AllowVehicle('BULK-LIQUID', VT::Tanker);
        AllowVehicle('BULK-LIQUID', VT::"Rail Wagon");
        AllowVehicle('BULK-LIQUID', VT::Vessel);
        AllowVehicle('BULK-DRY', VT::Tipper);
        AllowVehicle('BULK-DRY', VT::"Rail Wagon");
        AllowVehicle('BULK-DRY', VT::Vessel);
        AllowVehicle('OVERSIZED', VT::Flatbed);
        AllowVehicle('OVERSIZED', VT::"Rail Wagon");
        AllowVehicle('OVERSIZED', VT::Vessel);
        AllowVehicle('VEHICLES', VT::"Car Carrier");
        AllowVehicle('VEHICLES', VT::Vessel);
        AllowVehicle('VEHICLES', VT::"Rail Wagon");
        AllowVehicle('LIVESTOCK', VT::"Livestock Carrier");
        AllowVehicle('GAS', VT::Tanker);
        AllowVehicle('GAS', VT::Flatbed);
        AllowVehicle('GAS', VT::"Box Truck");
    end;

    local procedure InsertIndustryProfiles()
    var
        IT: Enum "LMS Industry Type";
        TM: Enum "LMS Transport Mode";
    begin
        // Code, Description, Type, Lot, Serial, Temp, Hazmat, Customs, POD, Insurance, Max transit h, Mode, Default goods type
        AddProfile(GeneralTok, 'General trade', IT::General, false, false, false, false, true, false, false, 0, TM::Road, 'GENERAL');
        AddProfile('PHARMA', 'Pharmaceutical & healthcare', IT::Pharmaceutical, true, false, true, false, true, true, true, 72, TM::Road, 'PHARMA-CRT');
        AddProfile('FOOD', 'Food & beverage', IT::"Food & Beverage", true, false, true, false, true, true, false, 48, TM::Road, 'AMBIENT-FOOD');
        AddProfile('AUTOMOTIVE', 'Automotive', IT::Automotive, false, true, false, false, true, true, true, 0, TM::Road, 'AUTO-PARTS');
        AddProfile('RETAIL', 'Retail & e-commerce', IT::Retail, false, false, false, false, false, true, false, 0, TM::Courier, 'PARCEL');
        AddProfile('CONSTRUCTION', 'Construction', IT::Construction, false, false, false, false, false, true, false, 0, TM::Road, 'BUILDING-MAT');
        AddProfile('CHEMICALS', 'Chemicals', IT::Chemicals, true, false, false, true, true, true, true, 0, TM::Road, 'CORROSIVE');
        AddProfile('AGRICULTURE', 'Agriculture & fresh produce', IT::Agriculture, true, false, false, false, true, true, false, 36, TM::Road, 'FRESH-PRODUCE');
        AddProfile('ELECTRONICS', 'Electronics & technology', IT::Electronics, false, true, false, false, true, true, true, 0, TM::Air, 'ELECTRONICS');
        AddProfile('OILGAS', 'Oil & gas', IT::"Oil & Gas", true, false, false, true, true, true, true, 0, TM::Road, 'FUEL-BULK');
        AddProfile('TEXTILE', 'Textile & apparel', IT::Textile, false, false, false, false, true, false, false, 0, TM::Sea, 'TEXTILES');
        AddProfile('MINING', 'Mining & minerals', IT::Mining, false, false, false, false, true, true, false, 0, TM::Rail, 'BULK-DRY');
    end;

    local procedure InsertIndustryDocuments()
    var
        DC: Enum "LMS Document Condition";
    begin
        // Industry-independent requirements (blank industry code)
        AddIndustryDocument('', 'DG-DECL', 'Dangerous goods declaration', DC::"Hazardous Goods", true);
        AddIndustryDocument('', 'SDS', 'Safety data sheet (SDS/MSDS)', DC::"Hazardous Goods", true);
        AddIndustryDocument('', 'COMM-INVOICE', 'Commercial invoice', DC::"Cross-Border", true);
        AddIndustryDocument('', 'PACKING-LIST', 'Packing list', DC::"Cross-Border", true);
        AddIndustryDocument('', 'CUSTOMS-DECL', 'Customs / export declaration', DC::"Cross-Border", true);
        AddIndustryDocument('', 'TEMP-LOG', 'Temperature data-logger record', DC::"Temperature Controlled", false);
        AddIndustryDocument('', 'OVERSIZE-PERMIT', 'Abnormal load permit / escort', DC::Oversized, true);
        // Industry-specific requirements
        AddIndustryDocument('PHARMA', 'GDP-CERT', 'GDP compliance certificate', DC::Always, true);
        AddIndustryDocument('PHARMA', 'TEMP-LOG', 'Temperature data-logger record', DC::"Temperature Controlled", true);
        AddIndustryDocument('PHARMA', 'IMPORT-PERMIT', 'Pharmacy board import permit', DC::"Cross-Border", true);
        AddIndustryDocument('FOOD', 'HEALTH-CERT', 'Health / sanitary certificate', DC::"Cross-Border", true);
        AddIndustryDocument('FOOD', 'TEMP-LOG', 'Temperature data-logger record', DC::"Temperature Controlled", true);
        AddIndustryDocument('AGRICULTURE', 'PHYTO-CERT', 'Phytosanitary certificate', DC::"Cross-Border", true);
        AddIndustryDocument('AGRICULTURE', 'ORIGIN-CERT', 'Certificate of origin', DC::"Cross-Border", false);
        AddIndustryDocument('CHEMICALS', 'TREM-CARD', 'Transport emergency card (TREM card)', DC::"Hazardous Goods", true);
        AddIndustryDocument('OILGAS', 'TREM-CARD', 'Transport emergency card (TREM card)', DC::"Hazardous Goods", true);
        AddIndustryDocument('OILGAS', 'LOADING-CERT', 'Loading / quantity certificate', DC::Always, true);
        AddIndustryDocument('ELECTRONICS', 'INSURANCE-CERT', 'Cargo insurance certificate', DC::"High Value", true);
        AddIndustryDocument('AUTOMOTIVE', 'INSURANCE-CERT', 'Cargo insurance certificate', DC::"High Value", true);
        AddIndustryDocument('AUTOMOTIVE', 'VEHICLE-LOGBOOK', 'Vehicle logbook / title documents', DC::"High Value", false);
        AddIndustryDocument('MINING', 'MINERAL-PERMIT', 'Mineral movement permit', DC::Always, true);
        AddIndustryDocument('CONSTRUCTION', 'DELIVERY-NOTE', 'Signed delivery note', DC::Always, false);
    end;

    local procedure InsertFreightRates()
    var
        FreightRate: Record "LMS Freight Rate";
        TM: Enum "LMS Transport Mode";
        RB: Enum "LMS Rate Basis";
    begin
        if not FreightRate.IsEmpty() then
            exit;
        // Mode, Goods type, Zone, Basis, Rate, Minimum charge, Volumetric factor, Description
        AddRate(TM::Road, '', '', RB::"Chargeable Weight", 0.15, 50, 333, 'Road - general cargo');
        AddRate(TM::Road, 'CHILLED', '', RB::"Chargeable Weight", 0.25, 80, 333, 'Road - chilled');
        AddRate(TM::Road, 'FROZEN', '', RB::"Chargeable Weight", 0.3, 90, 333, 'Road - frozen');
        AddRate(TM::Road, 'FUEL-BULK', '', RB::"Per Km", 2.5, 150, 0, 'Road tanker - fuel');
        AddRate(TM::Road, 'BULK-DRY', '', RB::"Per Kg", 0.05, 100, 0, 'Road tipper - bulk');
        AddRate(TM::Road, 'OVERSIZED', '', RB::"Per Km", 4, 500, 0, 'Road low-loader');
        AddRate(TM::Rail, '', '', RB::"Per Kg", 0.04, 80, 0, 'Rail freight');
        AddRate(TM::Sea, '', '', RB::"Per Cubic Meter", 45, 150, 0, 'Sea freight LCL');
        AddRate(TM::Air, '', '', RB::"Chargeable Weight", 3.5, 100, 167, 'Air freight');
        AddRate(TM::Courier, '', '', RB::"Chargeable Weight", 1.5, 10, 200, 'Courier / parcel');
    end;

    local procedure AddGoodsType(NewCode: Code[20]; NewDescription: Text[100]; NewHandlingClass: Enum "LMS Handling Class"; TempControlled: Boolean; MinTemp: Decimal; MaxTemp: Decimal; IsHazardous: Boolean; UNNumber: Code[10]; HazardClass: Code[10]; PackingGroup: Code[5]; IsStackable: Boolean; MinShelfLife: Integer; SurchargePct: Decimal; InsurancePct: Decimal)
    var
        LMSGoodsType: Record "LMS Goods Type";
    begin
        if LMSGoodsType.Get(NewCode) then
            exit;
        LMSGoodsType.Init();
        LMSGoodsType.Code := NewCode;
        LMSGoodsType.Description := NewDescription;
        LMSGoodsType."Handling Class" := NewHandlingClass;
        LMSGoodsType."Temperature Controlled" := TempControlled;
        LMSGoodsType."Min. Temperature (C)" := MinTemp;
        LMSGoodsType."Max. Temperature (C)" := MaxTemp;
        LMSGoodsType.Hazardous := IsHazardous;
        LMSGoodsType."UN Number" := UNNumber;
        LMSGoodsType."Hazard Class" := HazardClass;
        LMSGoodsType."Packing Group" := PackingGroup;
        LMSGoodsType.Stackable := IsStackable;
        LMSGoodsType."Min. Shelf Life (Days)" := MinShelfLife;
        LMSGoodsType."Handling Surcharge %" := SurchargePct;
        LMSGoodsType."Insurance Rate %" := InsurancePct;
        LMSGoodsType.Insert();
    end;

    local procedure AllowVehicle(GoodsTypeCode: Code[20]; VehicleType: Enum "LMS Vehicle Type")
    var
        GoodsTypeVehicle: Record "LMS Goods Type Vehicle";
    begin
        if GoodsTypeVehicle.Get(GoodsTypeCode, VehicleType) then
            exit;
        GoodsTypeVehicle.Init();
        GoodsTypeVehicle."Goods Type Code" := GoodsTypeCode;
        GoodsTypeVehicle."Vehicle Type" := VehicleType;
        GoodsTypeVehicle.Insert();
    end;

    local procedure AddProfile(NewCode: Code[20]; NewDescription: Text[100]; IndustryType: Enum "LMS Industry Type"; Lot: Boolean; Serial: Boolean; Temp: Boolean; Hazmat: Boolean; Customs: Boolean; POD: Boolean; Insurance: Boolean; MaxTransitHours: Decimal; TransportMode: Enum "LMS Transport Mode"; DefaultGoodsType: Code[20])
    var
        IndustryProfile: Record "LMS Industry Profile";
    begin
        if IndustryProfile.Get(NewCode) then
            exit;
        IndustryProfile.Init();
        IndustryProfile.Code := NewCode;
        IndustryProfile.Description := NewDescription;
        IndustryProfile."Industry Type" := IndustryType;
        IndustryProfile."Requires Lot Tracking" := Lot;
        IndustryProfile."Requires Serial Tracking" := Serial;
        IndustryProfile."Requires Temp. Control" := Temp;
        IndustryProfile."Requires Hazmat Handling" := Hazmat;
        IndustryProfile."Requires Customs Data" := Customs;
        IndustryProfile."Requires Proof of Delivery" := POD;
        IndustryProfile."Requires Insurance" := Insurance;
        IndustryProfile."Max. Transit Hours" := MaxTransitHours;
        IndustryProfile."Default Transport Mode" := TransportMode;
        IndustryProfile."Default Goods Type Code" := DefaultGoodsType;
        IndustryProfile.Insert();
    end;

    local procedure AddIndustryDocument(IndustryCode: Code[20]; DocumentCode: Code[20]; NewDescription: Text[100]; NewCondition: Enum "LMS Document Condition"; IsMandatory: Boolean)
    var
        LMSIndustryDocument: Record "LMS Industry Document";
    begin
        if LMSIndustryDocument.Get(IndustryCode, DocumentCode) then
            exit;
        LMSIndustryDocument.Init();
        LMSIndustryDocument."Industry Code" := IndustryCode;
        LMSIndustryDocument."Document Code" := DocumentCode;
        LMSIndustryDocument.Description := NewDescription;
        LMSIndustryDocument.Condition := NewCondition;
        LMSIndustryDocument.Mandatory := IsMandatory;
        LMSIndustryDocument.Insert();
    end;

    local procedure AddRate(TransportMode: Enum "LMS Transport Mode"; GoodsTypeCode: Code[20]; ZoneCode: Code[10]; RateBasis: Enum "LMS Rate Basis"; NewRate: Decimal; MinimumCharge: Decimal; VolumetricFactor: Decimal; NewDescription: Text[100])
    var
        FreightRate: Record "LMS Freight Rate";
    begin
        FreightRate.Init();
        FreightRate."Entry No." := 0;
        FreightRate."Transport Mode" := TransportMode;
        FreightRate."Goods Type Code" := GoodsTypeCode;
        FreightRate."Zone Code" := ZoneCode;
        FreightRate."Rate Basis" := RateBasis;
        FreightRate.Rate := NewRate;
        FreightRate."Minimum Charge" := MinimumCharge;
        FreightRate."Volumetric Factor (kg/m3)" := VolumetricFactor;
        FreightRate.Description := NewDescription;
        FreightRate.Insert(true);
    end;
}
