version 18

// TODO: Make sure the numbers presented in the table are correct!

// Clear all collections.
collect clear

// Get the levels for the two types of air purifier.
local port = "Portable" : `: value label treatment'
local ceil = "Ceiling"  : `: value label treatment'

// Make each table.
foreach table of global tables {
  collect create `table'

  // TODO: Define titles and notes for the different tables.
  collect title ${`table'_table_title}
  collect notes "${`table'_table_notes}"
  
  // Collect estimates of mean outcomes and of treatment effect.
  foreach y of global `table'_outcomes {
    collect mean = _r_b                        , tags(outcome[`y']) : mean `y' , over(treatment)
    collect irr = _r_b  cil = _r_lb ciu = _r_ub, tags(outcome[`y']) : estimates restore `table'_`y'
  }

  // Collect p-values for superiority of any air purification over no air purification.
  foreach y of global `table'_outcomes {
    estimates restore `table'_`y'
    if e(cmd) != "xpopoisson" local eqn `y'
    if e(cmd) == "xpopoisson" local eqn // No equation for this type of model.
    collect psup = r(p) , tags(outcome[`y']) : test _b[`eqn':`port'.treatment] = _b[`eqn':`ceil'.treatment] = 0
  }

  // Collect p-values for noninferiority of portable versus ceiling.
  foreach y of global `table'_outcomes {
    estimates restore `table'_`y'
    if e(cmd) != "xpopoisson" local eqn `y'
    if e(cmd) == "xpopoisson" local eqn // No equation for this type of model.
    nlcom _b[`eqn':`port'.treatment] - _b[`eqn':`ceil'.treatment] , post
    collect pnon = normal(sign(_b[_nl_1])*sqrt(r(chi2))) , tags(outcome[`y']) : test _b[_nl_1] = $log_margin  
  }

  // Label the levels of the outcome dimension.
  collect label levels outcome ${`table'_outcome_labels}

  // Label the p-value levels of results.
  collect label levels result psup "Superiority of air purification" pnon "Noninferiority (portable vs ceiling)"

  // Label the mean levels of results.
  collect label levels result mean "Mean"

  // Label the irr levels of results.
  collect label levels result irr "RR"

  // Label cil and ciu
  collect label levels result cil "[95%" ciu "CI]"

  // Lay out the table.
  collect layout (outcome) (treatment#result[mean] treatment[2 3]#result[irr cil ciu] result[psup pnon])

  // Style the table.
  collect style cell , nformat(%7.2f)
  collect style cell result[cil], nformat(%7.2f) sformat("[%s")
  collect style cell result[ciu], nformat(%7.2f) sformat("%s]")
  collect style cell result[psup pnon] , nformat(%7.3f) minimum(0.001)
  collect style cell border_block, border(right, pattern(nil))
  collect style cell , font(, size(9))
  collect style column , dups(center) // Center duplicated column titles.
  collect style notes , font(, size(9) italic)
  collect style putdocx, layout(autofitcontents)
}
