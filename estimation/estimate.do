version 18

// Perform estimation; the models are competing for selection on the basis of AIC.
tempname aic this_aic

foreach analysis in itt pp {
  foreach y of global `analysis'_outcomes {
    scalar `aic' = maxdouble()

    if "`analysis'" == "itt" local models ${model_types}
    if "`analysis'" == "pp"  local models nbreg
    foreach model_type of local models {
      disp "{hline}"

      local model `y'_`analysis'_`model_type'_model
      disp "Analysis for: `model'"
      disp "${`model'}"
      ${`model'}
      assert e(converged)
      estimates store `model'
    
      // Determine the model with lowest (best) AIC and store it for the outcome.
      estat ic
      scalar `this_aic' = r(S)[1,"AIC"]
      if `this_aic' < `aic' {
        estimates store `analysis'_`y' // The best model is saved using the outcome variable name.
        scalar `aic' = `this_aic'
      }
    }
  }
}

// Run the exploratory analysis.
${exploratory_model}
assert e(converged)
estimates store exploratory_${exploratory_outcomes}
