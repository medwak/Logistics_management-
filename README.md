# Logistics Management for Microsoft Dynamics 365 Business Central (Navision)

A multi-industry, multi-goods logistics management extension for **Microsoft Dynamics 365 Business Central**, the cloud and on-premises successor of **Microsoft Dynamics NAV (Navision)**. It is written in AL as a standard extension (no changes to base objects). It installs on Business Central 24 (2024 release wave 1) or later, online or on-premises.

It handles shipments of **any kind of goods**: general cargo, cold-chain, frozen, dangerous goods, bulk liquids and solids, oversized machinery, high-value electronics, finished vehicles, live animals and parcels. It applies the rules of the **industry** each customer belongs to, such as pharmaceutical, food & beverage, chemicals, oil & gas, automotive, electronics, construction, mining, agriculture, retail and textile.

---

## Features

| Area | What it does |
|---|---|
| **Industry profiles** | One profile per industry you serve. Each profile sets lot/serial tracking, temperature control, hazmat, customs data, proof of delivery, insurance, max. transit time, default transport mode and default goods type. Customers are linked to a profile. |
| **Goods types** | Handling class (standard, fragile, chilled, frozen, hazardous, bulk liquid/dry, oversized, high value, live animals), temperature range, UN number / hazard class / packing group, stackability, min. shelf life, handling surcharge %, insurance rate %, and the vehicle types allowed to carry them. |
| **Shipments** | A shipment document with header and lines. Lines can be **company items** or **third-party customer goods** that are not in the item master, so it works for shippers and for 3PL providers alike. Each line holds weight, volume, pallets, declared value, lot, serial number, expiry date, HS code and country of origin. |
| **Compliance engine** | Runs automatically on release. It checks goods against the vehicle (type, temperature range, hazmat certification, payload, volume, pallets, transport mode), the driver (license, ADR certificate), shelf life, expiry, mixed temperature ranges, industry-profile requirements and required documents, then applies **industry-specific rule sets**. |
| **Required documents** | A checklist per industry, optionally conditional: *always*, *hazardous goods*, *temperature controlled*, *cross-border*, *high value* or *oversized*. Examples are the DG declaration, SDS, GDP certificate, health/phytosanitary certificates, customs declaration and abnormal-load permit. Mandatory documents block the release until they are received. |
| **Freight rating** | Rate cards by transport mode, goods type, zone, start date and weight break. The rate basis can be flat, per kg, per m³, per km, per pallet or **chargeable weight** (actual vs. volumetric). Handling surcharges and insurance are calculated from the goods types. |
| **Fleet & drivers** | Vehicles of 13 types (van, reefer, tanker, tipper, flatbed, car carrier, livestock carrier, container truck, aircraft, vessel, rail wagon, …) with capacities and capabilities. Drivers with license and hazmat certificate expiry dates. Vehicle and driver status follow the trips automatically. |
| **Routes** | Origin, destination, distance, transit time and rate zone. |
| **Tracking** | Status life-cycle Open → Released → Planned → Picked Up → In Transit / At Hub → Out for Delivery → Delivered, plus Exception and Cancelled. Every event is logged with location, GPS, temperature, vehicle and user. Proof of delivery is enforced where the industry requires it. |
| **Integration** | *Create Logistics Shipment* action on the Sales Order. Goods type on the Item Card. Industry profile on the Customer Card. Read-only REST API for portals, carriers and BI. |
| **Role Center** | A *Logistics Manager* profile with cues for open, ready-to-dispatch, in-transit, delivered-today, exception and late shipments, plus fleet availability. |

### Industry rule sets (out of the box)

| Industry type | Rule set | Highlights |
|---|---|---|
| Pharmaceutical & Healthcare | `LMS Pharma Compliance` | GDP: batch number and expiry required, short-dated stock warning, controlled temperature, hazmat segregation warning |
| Food & Beverage, Agriculture | `LMS Food Compliance` | No dangerous goods with food, expiry on perishables, goods must not expire before arrival, livestock carrier for live animals |
| Chemicals, Oil & Gas | `LMS Dangerous Goods Compliance` | Hazard class and packing group, explosives isolation, segregation of incompatible classes (e.g. flammables vs. oxidizers) |
| Automotive, Electronics | `LMS High Value Compliance` | Serial numbers on high-value goods, declared values, insurance cover, vetted driver |
| Construction, Mining | `LMS Heavy Cargo Compliance` | Oversized cargo on flatbed/rail/vessel, bulk dry on tipper, bulk liquid on tanker, non-stackable warnings |
| General, Retail, Textile | `LMS General Compliance` | Generic data-driven checks only |

The **generic checks** apply to every industry. They are driven entirely by data in the industry profiles, goods types, vehicles and drivers. You can therefore serve a new industry, or handle a new kind of goods, **by configuration alone**.

---

## Installation

1. Open the folder in **VS Code** with the **AL Language** extension.
2. Edit `.vscode/launch.json` to point at your sandbox or server, then run **AL: Download Symbols**.
3. Press **F5** (publish & debug) or **Ctrl+F5** (publish without debugging). For production, build the `.app` with **AL: Package** and install it via *Extension Management*.
4. When the extension is installed, the install codeunit creates default data in every company:
   - number series `LMS-SHIP` (SHP000001…)
   - 12 industry profiles, 23 goods types with allowed vehicle types
   - 22 required-document rules, 10 freight rates
   - the Logistics Setup record

   You can run this again at any time from **Logistics Setup → Load Default Industry Data**. Existing records are never overwritten.
5. Assign the permission set **LMS ADMIN** (configuration) or **LMS USER** (daily operations). To use the role center, choose the **Logistics Manager** profile in *My Settings*.

### Getting started

1. **Logistics Setup** – check the number series, default industry and volumetric factor.
2. **Industry Profiles** – review or adjust the industries you serve, and their **Required Documents**.
3. **Goods Types** – adjust the temperature ranges, hazmat data, surcharges and allowed vehicle types.
4. **Vehicles**, **Drivers**, **Routes**, **Freight Rates** – register your fleet and your tariffs.
5. On each **Customer Card**, set the *Logistics Industry Profile*. On each **Item Card**, set the *Logistics Goods Type*.
6. Create a shipment manually, or from a Sales Order (*Logistics → Create Logistics Shipment*), then:
   **Check Compliance → mark documents received → Release → Plan → Update Status (Picked Up … Delivered)**.

Units: weights are in **kg**, volumes in **m³**, temperatures in **°C**. Item weights and volumes are read from *Item → Gross Weight / Unit Volume* and from *Item Unit of Measure → Weight / Cubage*. Maintain those in kg and m³.

---

## Architecture

```
src/
├── Enums/                 Industry type, handling class, transport mode, vehicle type, statuses, rate basis, ...
├── Interfaces/            LMS IIndustry Compliance, LMS IFreight Rate Calculator
├── Tables/                Setup, industry profile, goods type, vehicle, driver, route, freight rate,
│                          shipment header/line, tracking entry, documents, cue, compliance issue (temp)
├── TableExtensions/       Item (goods type), Customer (industry profile)
├── Codeunits/
│   ├── LMSShipmentMgt     release / reopen / plan / status transitions / create from sales order
│   ├── LMSComplianceMgt   generic compliance engine + required documents
│   ├── LMSFreightCalcMgt  rate lookup, surcharge, insurance
│   ├── LMSTrackingMgt     tracking event log
│   ├── LMSSetupData       default multi-industry configuration
│   ├── FreightRateCalculators/   one codeunit per rate basis
│   └── IndustryCompliance/       one codeunit per industry rule set
├── Pages/                 lists, cards, shipment document, role center, activities, API
├── PageExtensions/        Item Card, Customer Card, Sales Order
├── Permissions/           LMS ADMIN, LMS USER
└── Profiles/              Logistics Manager
```

Object range: **50100–50199**. All objects use the `LMS` prefix.

### Extending

The extension is designed so that a new industry, rule or pricing model needs **no changes to this app**. Add it from a dependent extension instead.

**Add an industry with its own rules**

```al
enumextension 60000 "My Industry Types" extends "LMS Industry Type"
{
    value(60000; Aerospace)
    {
        Caption = 'Aerospace';
        Implementation = "LMS IIndustry Compliance" = "My Aerospace Compliance";
    }
}

codeunit 60000 "My Aerospace Compliance" implements "LMS IIndustry Compliance"
{
    procedure CheckShipment(ShipmentHeader: Record "LMS Shipment Header"; var TempComplianceIssue: Record "LMS Compliance Issue")
    begin
        // e.g. require an airworthiness certificate reference on every line
    end;
}
```

**Add a pricing model**: extend `"LMS Rate Basis"` with a value that implements `"LMS IFreight Rate Calculator"`, for example per TEU, per hour or per zone matrix.

**Add handling classes, vehicle types, transport modes or document conditions**: all enums are extensible.

**Events** (integration events you can subscribe to):

| Codeunit | Event |
|---|---|
| LMS Compliance Mgt. | `OnBeforeCheckShipment`, `OnAfterCheckShipment`, `OnAfterIsDocumentConditionMet` |
| LMS Shipment Mgt. | `OnBeforeRelease`, `OnAfterRelease`, `OnBeforeSetStatus`, `OnAfterSetStatus`, `OnAfterIsTransitionAllowed`, `OnCreateFromSalesOrderOnBeforeModifyHeader`, `OnCreateFromSalesOrderOnBeforeInsertLine` |
| LMS Freight Calc. Mgt. | `OnBeforeFindFreightRate`, `OnAfterCalculateFreightAmount`, `OnAfterCalcInsuranceAmount` |
| LMS Tracking Mgt. | `OnBeforeInsertTrackingEntry`, `OnAfterInsertTrackingEntry` (e.g. to e-mail or SMS customers, or to call a webhook) |

### REST API

```
GET /api/medwak/logistics/v1.0/companies({companyId})/shipments
GET /api/medwak/logistics/v1.0/companies({companyId})/shipments?$filter=status eq 'In Transit'
```

The API is read-only. Tracking events can be recorded from code with `LMS Tracking Mgt.`.`LogEventDetailed` (for example from a telematics integration).

---

## Build status

The source compiles with the Microsoft AL compiler (`alc` 18.0) with **0 errors and 0 warnings** under CodeCop and UICop. Because the Microsoft symbol feeds were not reachable from the build environment, the base objects this app references were compiled against a stub package. That package declares the same Base Application tables, fields and pages: Customer, Item, Item Unit of Measure, Sales Header/Line, No. Series, and so on. Run **AL: Download Symbols** against your own environment, then build there to confirm against the real Base Application. Automated tests (an AL test app) are not included yet.
