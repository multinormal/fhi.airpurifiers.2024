version 18

// Clear all collections.
collect clear

// Make a table for the main analyses.
collect create main

collect irr = _r_b  , tags(outcome[pm2_5]) : estimates restore pm2_5
collect mean = _r_b , tags(outcome[pm2_5]) : mean pm2_5 , over(treatment)

collect irr = _r_b  , tags(outcome[voc])   : estimates restore voc
collect mean = _r_b , tags(outcome[voc])   : mean voc , over(treatment)

collect layout (outcome) (treatment#result[mean] treatment#result[irr])
