version 18

// Define the covariates.
local covariates i.treatment i.sensor pm2_5_lagged i.undefined_lags

// Define the VCE option.
local vce vce(cluster class)

// Define the competing types of model:
global model_types zinb nbreg poiss

// Define the competing models for PM2.5:
global pm2_5_zinb_model  zinb    pm2_5 `covariates' , exp(exposure) inf(_cons) irr `vce'
global pm2_5_nbreg_model nbreg   pm2_5 `covariates' , exp(exposure)            irr `vce' difficult
global pm2_5_poiss_model poisson pm2_5 `covariates' , exp(exposure)            irr `vce' difficult
