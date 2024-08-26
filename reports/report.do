version 18

// Some locals to make this file a little more readable.
local heading putdocx paragraph, style(Heading1)
local subhead putdocx paragraph, style(Heading2)
local newpara putdocx textblock begin, halign(both)
local putdocx textblock end putdocx textblock end

local p_fmt  %5.2f // Format used for P-values.
local e_fmt  %5.2f // Format used for estimates.
local pc_fmt %8.1f // Format used for percentages.

local tbl_num = 0  // A table counter.

// Start the document.
putdocx begin

// Title.
putdocx paragraph, style(Title)
putdocx text ("TODO: Trial Name")

// Author and revision information.
`newpara'
TODO: Name and institution
(<<dd_docx_display: c(current_date)>>)
putdocx textblock end
`newpara'
Generated using git revision: <<dd_docx_display: "${git_revision}">>
putdocx textblock end

// Introduction section.
`heading'
putdocx text ("Introduction")

`newpara'
This document presents methods and results for the TODO trial.
putdocx textblock end

// Methods section
`heading'
putdocx text ("Methods")

`newpara'
TODO: Explain rounding.
putdocx textblock end

`newpara'
We performed a prespecified exploratory analysis to identify time-varying covariates that 
may be associated with the primary outcome and assess the sensitivity of the treatment 
effect estimates to these covariates. We used partialing-out lasso Poisson regression (Stata's 
xpopoisson command) with the lasso penalty chosen using 10-fold cross-validation to 
select among the following covariates: indoor relative humidity; the school's existing ventilation 
system setting (low or high); weekday; baseline morning PM2.5 (modelled on the log scale); 
number of students attending class; and mean outdoor temperature. The model would not converge 
when we attempted to account for undefined lagged PM2.5 values, or if indoor temperature was 
included. We could not include indoor CO2 or sound level because a large number of values were 
missing for these variables.
putdocx textblock end

// Results section
`heading'
putdocx text ("Results")

`subhead '
putdocx text ("Estimates of treatment effect for the primary and secondary analyses")
collect set itt
putdocx collect

`subhead '
putdocx text ("Exploratory per-protocol estimates of treatment effect for the primary and secondary analyses")
collect set pp
putdocx collect

`subhead '
putdocx text ("Exploratory time-varying covariate adjusted analysis")

`newpara'
The time-varying covariates selected by lasso were indoor relative humidity, weekday, baseline morning PM2.5, 
and the school's existing ventilation system setting.
putdocx textblock end

collect set exploratory
putdocx collect

`newpara'
TODO: Add results.
putdocx textblock end

// Discussion
`heading'
putdocx text ("Discussion")

`newpara'
The results of the prespecified exploratory analysis should be interpreted cautiously because we 
were unable to account for undefined lags and could not include all time-varying covariates. 
Further, it was not possible to use a negative binomial model for this analysis, as was selected 
over the Poisson model on the basis of AIC in the main analyses, because Stata does not currently 
provide xpopoisson-like commands for negative binomial models.
putdocx textblock end


// References
`heading'
putdocx text ("References")

`newpara'
TODO: Add references.
putdocx textblock end

// Appendices

`heading'
putdocx text ("Appendix 1 — Protocol Deviations")

`newpara'
TODO: Describe any protocol deviations.
putdocx textblock end

`heading'
putdocx text ("Appendix 2 — Full Regression Results")

`newpara'
TODO: Present full regression tables.
putdocx textblock end

// Save the report to the specified filename.
putdocx save "${report_filename}", replace
