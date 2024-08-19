version 18

// Define the VCE option.
local vce vce(cluster class)

// Define the exposure option.
local exp exposure(exposure)

// Define the competing types of model:
global model_types zinb nbreg poiss

// Define the competing models for the outcomes:
foreach y of global outcomes {
  // Define the covariates.
  local covs i.treatment i.sensor `y'_lagged i.`y'_lagged_undef

  global `y'_zinb_model  zinb    `y' `covs' , `exp' inf(_cons) irr `vce'
  global `y'_nbreg_model nbreg   `y' `covs' , `exp'            irr `vce' difficult
  global `y'_poiss_model poisson `y' `covs' , `exp'            irr `vce' difficult
}
