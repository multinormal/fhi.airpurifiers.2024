version 18

// The processed data file.
global processed_data_file      "data/raw/airpurifiers.dta"
global processed_data_signature "17953:21(39106):2520784948:3078238665"

// The raw data file.
global data_file "data/raw/alldata_act_sp_comp.dta"
global signature "17953:28(88255):4076654981:2522187636"

global random_seed 1234

global report_filename "products/report.docx"

// Define the tables of results.
global tables itt exploratory pp

// Define the outcomes for the tables.
global itt_outcomes         pm2_5 voc
global exploratory_outcomes pm2_5
global pp_outcomes          pm2_5 voc

// Define labels for the outcome variables.
global pm2_5_label "PM2.5"
global voc_label   "VOC"

// Define labels for the outcomes for each table.
global itt_outcome_labels         pm2_5 $pm2_5_label voc $voc_label
global exploratory_outcome_labels pm2_5 $pm2_5_label
global pp_outcome_labels          pm2_5 $pm2_5_label voc $voc_label

// Define the competing types of model.
global model_types zinb nbreg poisson

// Define the margin for noninferiority analyses.
global log_margin = 0.34 // See SAP section 8.4 

// Define the variables to include in the exploratory analysis.
global exploratory_vars hum_comp vent_setting i.weekday base_pm no_students out_temp_mean

// Define a predicate for the per protocol analyses.
global itt_predicate if 1
global pp_predicate  if pp_data

// Define the table notes.
local notes "Sample means are unadjusted and do no account for the crossover design."
local notes "`notes' Rate ratios (RRs) are adjusted for the crossover design, sensor type, first-order autocorrelation, and clustering within classroom."
local notes "`notes' RR < 1 disfavors the reference (no air purification)."
global itt_table_notes "`notes'"

local notes "Sample means are unadjusted and do no account for the crossover design."
local notes "`notes' Rate ratios (RRs) are adjusted for the crossover design, sensor type, first-order autocorrelation,"
local notes "`notes' the time-varying covariates selected by the cross-validated lasso, and clustering within classroom."
local notes "`notes' RR < 1 disfavors the reference (no air purification)."
global exploratory_table_notes "`notes'"

local notes "Sample means are unadjusted and do no account for the crossover design."
local notes "`notes' Rate ratios (RRs) are adjusted for the crossover design, sensor type, first-order autocorrelation, and clustering within classroom."
local notes "`notes' The estimation sample was restricted to exclude measurements made when air purifiers"
local notes "`notes' were not running as planned."
local notes "`notes' RR < 1 disfavors the reference (no air purification)."
global pp_table_notes "`notes'"
