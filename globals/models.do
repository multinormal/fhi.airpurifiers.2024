version 18

// Define the independent variables.
local indvars i.treatment i.sensor

// Define the VCE option.
local vce vce(cluster class)

// Define the exposure option.
local exp exposure(exposure)

// Define the competing types of model for the main table:
global model_types zinb nbreg poiss

// Define the competing models for the outcomes:
foreach y of global main_outcomes {
  // Define the covariates.
  local covs `indvars' `y'_lagged i.`y'_lagged_undef

  global `y'_zinb_model  zinb    `y' `covs' , `exp' inf(_cons) irr `vce'
  global `y'_nbreg_model nbreg   `y' `covs' , `exp'            irr `vce' difficult
  global `y'_poiss_model poisson `y' `covs' , `exp'            irr `vce' difficult
}

// Define the model for the exploratory analysis (see SAP §8.5):

// The control variables
local controls controls((pm2_5_lagged) ${exploratory_vars})

// Define a predicate to include only observations for which lagged PM2.5 is defined; it
// was not possible to account for undefined lags using ML in the exploratory model.
local predicate pm2_5_lagged_undef == "nonmissing":pm2_5_lagged_undef

// The model.
global exploratory_model xpopoisson pm2_5 `indvars' if `predicate', `controls' `exp' `vce' xfolds(10) rseed(1234)

// TODO: Define the per protocol analysis.
