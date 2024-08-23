version 18

// TODO: Define the PP set using the info in Cathinka's email of 22/8/24.

// Load the data and check its signature is as expected.
if "${data_file}" == "data/raw/TODO" exit // TODO: REMOVE THIS LINE
use "${data_file}", replace
datasignature
assert r(datasignature) == "${signature}"

// Define the outcome variables.
foreach y of global outcomes {
  label variable `y' "${`y'_label} (outcome variable)"
  count if missing(`y')
  assert r(N) == 0
}

// TODO: It looks like Airthings provides counts (integers) and Digiref provides reals. How to handle?

// Define the treatment variable.
generate treatment = .
replace  treatment = 1 if luftrensing == "None"
replace  treatment = 2 if luftrensing == "Ceiling"
replace  treatment = 3 if luftrensing == "Portable"
label define treatment 1 "None" 2 "Ceiling" 3 "Portable"
label values treatment treatment
label variable treatment "Treatment"
local base = "None":`: value label treatment'
fvset base `base' treatment
count if missing(treatment)
assert r(N) == 0
drop luftrensing

// Define the sensor type variable.
tempvar sensor
rename sensor `sensor'
generate sensor = .
replace sensor = 1 if `sensor' == "Airthings"
replace sensor = 2 if `sensor' == "Digiref"
label define sensor 1 "Airthings" 2 "Digiref"
label values sensor sensor
label variable sensor "Sensor"
count if missing(sensor)
assert r(N) == 0

// Rename the time variable and add a label to it;
rename tidspunkt time
label variable time "Date and time"

// Drop hour, etc. because the time variable specifies
// date and time to a resolution of at least 1 second.
drop hour min min_round min_round_hms tid_norsk_normaltid
// TODO: What does time_diff code for?

// Generate lagged versions of the outcomes; need to do this by sensor within
// class within date, in order of time.
sort time
foreach y of global outcomes {
  bysort date class sensor (time): generate `y'_lagged = `y'[_n - 1]
  label variable `y'_lagged "Lagged ${`y'_label}"

  // Verify that the number of missing lags is as expected. We expect one
  // missing lag at the start of each day for each individual sensor. The study
  // ran for 9 weeks, with 5 days per week, with 3 classrooms, and 2 sensors
  // per class. This suggests 9*5*3*2 = 45 days * 3*2 = 270 missing lags. However,
  // the data actually contain only 44 unique dates (days), giving 44*3*2 = 264 
  // missing lags.
  count if missing(`y'_lagged)
  scalar missing_`y'_lagged = r(N)
  levelsof date
  assert r(r) * 3 * 2 == missing_`y'_lagged
}

// For each outcome, generate a factor variable that identifies each missing lag,
// so that these values can be estimated (section 8.2 of the SAP).
foreach y of global outcomes {
  tempvar undefined_lags
  generate `undefined_lags' = "nonmissing"
  replace  `undefined_lags' = "missing " + string(_n) if missing(`y'_lagged)
  encode   `undefined_lags' , generate(`y'_lagged_undef)
  label variable `y'_lagged_undef "Missing lags for ${`y'_label}"
  local base = "nonmissing":`: value label `y'_lagged_undef'
  fvset base `base' `y'_lagged_undef
}

// Set the undefined (i.e., missing) lags to zero.
foreach y of global outcomes {
  replace `y'_lagged = 0 if missing(`y'_lagged)
}

// Generate an exposure variable. We anticipated in the SAP having start and
// end times for the measurements to define the exposures, but we only have
// timestamps. We will therefore compute the exposures in the same way as
// we do for lags; for the "first" exposure for a given date, class, and sensor,
// where there is no preceding timestamp that can be used to compute the exposure,
// we will singly-impute the exposure to be the most common exposure time.
// 85.5% of exposures are about 300000ms (5 mins) and 14.5% are about
// 600000ms (10 mins), and there are 3 observations of about 20 mins.
bysort date class sensor (time): generate exposure = time - time[_n - 1]
tempvar F most_common
tab exposure , sort matrow(`F')
scalar `most_common' = `F'[1,1]
replace exposure = `most_common' if missing(exposure)
replace exposure = exposure / 60000 // Convert exposure to minutes.
label variable exposure "Exposure (mins)"

// Generate a logged version of morning baseline PM2.5; the original variable
// is quite skewed and cannot be included in the exploratory model. The +0.01
// prevents generating undefined values.
replace base_pm = log(base_pm + 0.01)
label variable base_pm "Baseline morning PM2.5 (log scale)"

// Label unlabelled variables. TODO
label variable class "Class"
label variable hum_comp "Indoor humidity (RH%)"
label variable weekday "Weekday"
label variable no_students "Number of students"
label variable out_temp_mean "Mean outside temperature"
label variable soundlevela "Sound level" // TODO: Why-a? Used?

// Drop unused/duplicated variables. TODO
assert school == class // We can drop school.
drop school
foreach x in navn stasjon {
  levelsof `x' , missing // Count missing, too.
  assert r(r) == 1 // Constant across all observations.
  drop `x'
}

// TODO: Do we need any of the unlabelled variables?
// TODO: Ensure all variables are labelled.
