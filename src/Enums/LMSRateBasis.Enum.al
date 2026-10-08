/// <summary>
/// How a freight rate is applied. Each value implements its own calculation.
/// Extend this enum to add new pricing models (e.g. per TEU, per hour).
/// </summary>
enum 50105 "LMS Rate Basis" implements "LMS IFreight Rate Calculator"
{
    Extensible = true;
    Caption = 'Rate Basis';

    value(0; Flat)
    {
        Caption = 'Flat Rate';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Flat Rate Calc.";
    }
    value(1; "Per Kg")
    {
        Caption = 'Per Kg';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Per Kg Rate Calc.";
    }
    value(2; "Per Cubic Meter")
    {
        Caption = 'Per Cubic Meter';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Per Volume Rate Calc.";
    }
    value(3; "Per Km")
    {
        Caption = 'Per Km';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Per Km Rate Calc.";
    }
    value(4; "Per Pallet")
    {
        Caption = 'Per Pallet';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Per Pallet Rate Calc.";
    }
    value(5; "Chargeable Weight")
    {
        Caption = 'Chargeable Weight (max of actual / volumetric)';
        Implementation = "LMS IFreight Rate Calculator" = "LMS Chargeable Wt. Rate Calc.";
    }
}
