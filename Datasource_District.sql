--Sql.Database - rightsideup\infrasp1 District query

Select 
	 fp.Description performance_period
	,fp.FiscalYearID, concat(fp.FiscalYearID-1 ,'-',right(fp.FiscalYearID,2)) as fiscal_year_yy
	,case when ou.org_name_new = 'North Island Central Coast' then 'North Island - Central Coast' 
	when ou.org_name_new = 'Skeena/Stikine' then 'Skeena Stikine' 
	when ou.org_name_new = 'Coast Mountain' then 'Coast Mountains' 
	else ou.org_name_new 
	end as district_name
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
	, CONCAT('#', right(CONVERT( char(8), CONVERT(VARBINARY(8), rr.Colour), 2),2),substring(CONVERT( char(8), CONVERT(VARBINARY(8), rr.Colour), 2),5,2),substring(CONVERT( char(8), CONVERT(VARBINARY(8), rr.Colour), 2),3,2)) risk_hex_color
	, case when pmd.RiskRatingID ='1' then '#FFFFFF' else '#000000' end foreground_color

	from PerformanceMeasure pm
left join PerformanceMeasureOrgUnit pmo on (pmo.PerformanceMeasureID = pm.PerformanceMeasureID)
left join PerformanceMeasureData pmd  on (pmo.PerformanceMeasureOrgUnitID = pmd.PerformanceMeasureOrgUnitID)
	left join DataEntryPeriod dp on (pmd.DataEntryPeriodID = dp.DataEntryPeriodID)
	left join FiscalPeriod fp on (fp.FiscalPeriodID = dp.FiscalPeriodID)
	left join FiscalYearTarget fyt on (fyt.FiscalYearID = fp.FiscalYearID  and fyt.PerformanceMeasureID = pm.PerformanceMeasureID)
	left join (
		Select *, rtrim(replace( ou.Name,	substring(ou.Name, CHARINDEX('(', ou.Name),	CHARINDEX(')', ou.Name) -CHARINDEX('(', ou.Name)+1),'' )) org_name_new
		from OrgUnit ou
		) ou on (ou.OrgUnitID = pmo.OrgUnitID)
	left join RiskRating rr on (pmd.RiskRatingID = rr.RiskRatingID)

	left join OrgUnit pu on (ou.ParentOrgUnitID = pu.OrgUnitID)
	left join OrgUnit gpu on (pu.ParentOrgUnitID = gpu.OrgUnitID)
	left join OrgUnit ggpu on (gpu.ParentOrgUnitID = ggpu.OrgUnitID)
	where 1=1 
and ( (pm.Description like '%Completion%' or pm.Description like '%Cutting%' or pm.Description like '%Range Act%' )
		and (pmo.IsRootLevel= '1')
)
	and (pm.Description not like '%DO NOT USE%')
	and ou.Name not like '% Area' and ou.Name not like '% Divisions'
;
