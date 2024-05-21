--Sql.Database - rightsideup\infrasp1 Area query

Select 
 fp.Description performance_period
,fp.FiscalYearID
, ou.Name as area_name
, ou.ShortName as area_code
, pmo.OrgUnitID area_id
, fp.ShortDescription
, fp.StartDate
, fp.EndDate
, pmd.PerformanceMeasureDataID
, pm.Description pm_name
, pmd.DataEntryPeriodID
, pmd.PerformanceMeasureOrgUnitID
, fyt.TargetNumber/100 as Target_pct
, pmd.Numerator
, pmd.Denominator
, pmd.RiskRatingID
, rr.ShortDescription risk_category
, rr.Description risk_description
, pmo.PerformanceMeasureID
, pmo.IsRootLevel
, pu.OrgUnitID div_id
, pu.Name div_name
, pu.ShortName div_sname
, gpu.OrgUnitID ministry_id
, gpu.Name ministry_name
, gpu.ShortName ministry_sname
, pmd.Comment 
,  rr.Colour risk_color
from PerformanceMeasure pm
left join PerformanceMeasureOrgUnit pmo on (pmo.PerformanceMeasureID = pm.PerformanceMeasureID)
left join PerformanceMeasureData pmd  on (pmo.PerformanceMeasureOrgUnitID = pmd.PerformanceMeasureOrgUnitID)
left join DataEntryPeriod dp on (pmd.DataEntryPeriodID = dp.DataEntryPeriodID)
left join FiscalPeriod fp on (fp.FiscalPeriodID = dp.FiscalPeriodID)
left join FiscalYearTarget fyt on (fyt.FiscalYearID = fp.FiscalYearID  and fyt.PerformanceMeasureID = pm.PerformanceMeasureID)
left join OrgUnit ou on (ou.OrgUnitID = pmo.OrgUnitID)
left join RiskRating rr on (pmd.RiskRatingID = rr.RiskRatingID)
left join OrgUnit pu on (ou.ParentOrgUnitID = pu.OrgUnitID)
left join OrgUnit gpu on (pu.ParentOrgUnitID = gpu.OrgUnitID)
left join OrgUnit ggpu on (gpu.ParentOrgUnitID = ggpu.OrgUnitID)

left join OptimizationDirection op on (op.OptimizationDirectionID = pm.OptimizationDirectionID)
left join Status st on (st.StatusID = pm.StatusID)
left join CalculationType ctp on ctp.CalculationTypeID = pm.CalculationTypeID
left join CalculationClass cc on cc.CalculationClassID= pm.CalculationClassID
left join Source src on (src.SourceID = pm.SourceID)
left join FunctionMap fmp on (fmp.FunctionMapID = pm.FunctionMapID)
left join FunctionMap fmpp on (fmpp.FunctionMapID = fmp.ParentFunctionMapID)
left join FunctionMap fmpt on (fmpt.FunctionMapID = fmpp.ParentFunctionMapID)

where 1=1 
and ( (pm.Description like '%Completion%' or pm.Description like '%Cutting%' or pm.Description like '%Range Act%' )
		and (pmo.IsRootLevel= '0'))
;