version 18

global data_file "data/raw/alldata_act_sp_comp.dta"
global signature "17953:27(67626):1155905459:299325766"

global random_seed 1234          // TODO: Change random seed if necessary.

global report_filename "products/report.docx"

// Define the outcome variables.
global outcomes pm2_5 voc
global pm2_5_label "PM2.5"
global voc_label   "VOC"

// Define the margin for noninferiority analyses.
global log_margin = 0.34 // See SAP section 8.4 
