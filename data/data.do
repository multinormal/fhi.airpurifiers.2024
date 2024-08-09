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

// TODO: Generate a lagged version of y

