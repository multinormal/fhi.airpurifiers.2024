version 16.1

// Load the data and check its signature is as expected.
if "${data_file}" == "data/raw/TODO" exit // TODO: REMOVE THIS LINE
use "${data_file}", replace
datasignature
assert r(datasignature) == "${signature}"

// Define the outcome variable.
rename pm2_5 y
label variable y "PM2.5 (outcome)"
count if missing(y)
assert r(N) == 0

// TODO: It looks like Airthings provides counts (integers) and Digiref provides reals. How to handle?

// Define the treatment variable.
generate treatment = .
replace  treatment = 1 if luftrensing == "None"
replace  treatment = 2 if luftrensing == "Ceiling"
replace  treatment = 3 if luftrensing == "Portable"
label define treatment 1 "None" 2 "Ceiling" 3 "Portable"
label values treatment treatment
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
count if missing(sensor)
assert r(N) == 0

// Rename the time variable and add a label to it;
rename tidspunkt time
label variable time "Date and time"

// Drop hour, etc. because the time variable specifies
// date and time to a resolution of at least 1 second.
// TODO: REINSTATE drop hour min min_round min_round_hms tid_norsk_normaltid
// TODO: What does time_diff code for?


// Generate a lagged version of y; need to do this by sensor within
// class within date, in order of time.
sort time
bysort date class sensor (time): generate y_lagged = y[_n - 1]
// Verify that the number of missing lags is as expected. We expect one
// missing lag at the start of each day for each individual sensor. The study
// ran for 9 weeks, with 5 days per week, with 3 classrooms, and 2 sensors
// per class. This suggests 9*5*3*2 = 45 days * 3*2 = 270 missing lags. However,
// the data actually contain only 44 unique dates (days), giving 44*3*2 = 264 
// missing lags.
count if missing(y_lagged)
scalar missing_y_lagged = r(N)
levelsof date
assert r(r) * 3 * 2 == missing_y_lagged


