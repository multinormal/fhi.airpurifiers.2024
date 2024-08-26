version 18

global data_file "data/raw/alldata_act_sp_comp.dta"
global signature "17953:28(88255):4076654981:2522187636"

global random_seed 1234          // TODO: Change random seed if necessary.

global report_filename "products/report.docx"

// Define the tables of results.
global tables main exploratory // TODO: Add per protocol.

// Define the outcomes for the tables.
global main_outcomes pm2_5 voc
global exploratory_outcomes pm2_5
// TODO: Per protocol outcomes

// Define labels for the outcome variables.
global pm2_5_label "PM2.5"
global voc_label   "VOC"

// Define labels for the outcomes for each table.
global main_outcome_labels pm2_5 $pm2_5_label voc $voc_label
global exploratory_outcome_labels pm2_5 $pm2_5_label
// TODO: Per protocol outcomes

// Define the margin for noninferiority analyses.
global log_margin = 0.34 // See SAP section 8.4 

// Define the variables to include in the exploratory analysis.
global exploratory_vars hum_comp vent_hast i.weekday base_pm no_students out_temp_mean
