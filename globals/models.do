version 18

// Define the independent variables.
local indvars i.treatment i.sensor

// Define the VCE option.
local vce vce(cluster class)

// Define the exposure option.
local exp exposure(exposure)

// Define the competing models for the outcomes:
foreach analysis in itt pp {
  // Define the predicate for the analysis.
  local if ${`analysis'_predicate}
  
  // For the ITT analyses, the SAP says we will to choose from among three
  // estimators for the main analysis, and will then use the select estimator
  // in subsequent analyses (i.e., per protocol), which we hard-code to be
  // the negative binomial.
  if "`analysis'" == "itt" local models ${model_types}
  if "`analysis'" == "pp"  local models nbreg
  local zinb_inf inflate(_cons) // Only need to define an inflation term for this model.

  // Define the models for .
  foreach y of global `analysis'_outcomes {
    // Define the covariates.
    local covs `indvars' `y'_lagged i.`y'_lagged_undef

    // Define the models for this outcomes, analysis, and model type.
    foreach model of local models {
      global `y'_`analysis'_`model'_model  `model' `y' `covs' `if' , `exp' ``model'_inf' irr `vce' difficult
    }
  }
}

// Define the model for the exploratory analysis (see SAP §8.5):

// The control variables
local controls controls((pm2_5_lagged) ${exploratory_vars})

// Define a predicate to include only observations for which lagged PM2.5 is defined; it
// was not possible to account for undefined lags using ML in the exploratory model.
local if if pm2_5_lagged_undef == "nonmissing":pm2_5_lagged_undef

// The model.
global exploratory_model xpopoisson pm2_5 `indvars' `if', `controls' `exp' `vce' xfolds(10) rseed(1234)
