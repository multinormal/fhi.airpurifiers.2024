version 18

// Perform estimation; the models are competing for selection on the basis of AIC.
tempname aic this_aic
scalar `aic' = maxdouble()
foreach model_type of global model_types {
  local model pm2_5_`model_type'_model
  ${`model'}
  assert e(converged)
  estimates store `model'

  // Determine the model with lowest (best) AIC and store it for the outcome.
  estat ic
  scalar `this_aic' = r(S)[1,"AIC"]
  if `this_aic' < `aic' {
    estimates store pm2_5
    scalar `aic' = `this_aic'
  }
}
