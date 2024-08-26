version 18

// Perform estimation; the models are competing for selection on the basis of AIC.
tempname aic this_aic

foreach y of global main_outcomes {
  scalar `aic' = maxdouble()
  foreach model_type of global model_types {
    local model `y'_`model_type'_model
    ${`model'}
    assert e(converged)
    estimates store `model'
  
    // Determine the model with lowest (best) AIC and store it for the outcome.
    estat ic
    scalar `this_aic' = r(S)[1,"AIC"]
    if `this_aic' < `aic' {
      estimates store main_`y' // The best model is saved using the outcome variable name.
      scalar `aic' = `this_aic'
    }
  }
}

// Run the exploratory analysis.
${exploratory_model}
assert e(converged)
estimates store exploratory_${exploratory_outcomes}

// TODO: Run the per protocol analysis.
