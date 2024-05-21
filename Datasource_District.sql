--Sql.Database - rightsideup\infrasp1 District query

Select 
	 fp.Description performance_period
	,fp.FiscalYearID
	, ou.Name as district_name
	, ou.ShortName as district_code
	, pmo.OrgUnitID district_id
	, fp.ShortDescription
	, fp.StartDate
	, fp.EndDate
	, pmd.PerformanceMeasureDataID
	, pm.Description pm_name
	, pmd.DataEntryPeriodID
	, pmd.PerformanceMeasureOrgUnitID
	, fyt.TargetNumber/100 as Target_pct
	, Numerator
	, Denominator
	, pmd.RiskRatingID
	, rr.ShortDescription risk_category
	, rr.Description risk_description
	, pmo.PerformanceMeasureID
	, pmo.IsRootLevel
	, pu.OrgUnitID region_id
	, pu.Name region_name
	, pu.ShortName region_sname
	, gpu.OrgUnitID area_id
	, gpu.Name area_name
	, gpu.ShortName area_sname
	, ggpu.OrgUnitID div_id
	, ggpu.Name div_name
	, ggpu.ShortName div_sname 
	, pmd.Comment 
	,  rr.Colour risk_color
	
	,pm.NumeratorUnit
	,pm.DenominatorUnit
	,pm.OptimizationDirectionID
	,op.Description Optimization_direction
	,st.Description status
	,pm.CalculationTypeID CalcNum
	,ctp.Description as CalcType
	,pm.CalculationClassID
	,cc.Description as CalcClass
	,fyt.TargetNumber
	,rr.RiskRatingID riskRatingNum
	,rr.Description RiskRatingDescription
	,rr.ShortDescription RiskRatingShortDescription
	,pm.SourceID
	,src.Description SourceName
	,src.ShortName SourceShortName
	,pm.FunctionMapID SubfunctionID
	,fmp.Description Subfunction
	,fmpp.Description as "Function"
	,fmpt.Description Theme
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
		and (pmo.IsRootLevel= '1')
)
;
