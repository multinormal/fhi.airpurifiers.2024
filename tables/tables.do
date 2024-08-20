version 18

// TODO: Eliminate the repetition here:

// Clear all collections.
collect clear

// Make a table for the main analyses.
collect create main

// IRRs and means for pm2_5.
collect irr = _r_b  cil = _r_lb ciu = _r_ub, tags(outcome[pm2_5]) : estimates restore pm2_5
collect mean = _r_b , tags(outcome[pm2_5]) : mean pm2_5 , over(treatment)

// IRRs and means for VOC.
collect irr = _r_b  cil = _r_lb ciu = _r_ub, tags(outcome[voc])   : estimates restore voc
collect mean = _r_b , tags(outcome[voc])   : mean voc , over(treatment)

// Test for superiority of any air purification over no air purification.
estimates restore pm2_5
local port = "Portable" : `: value label treatment'
local ceil = "Ceiling"  : `: value label treatment'
collect psup = r(p) , tags(outcome[pm2_5]) : test _b[pm2_5:`port'.treatment] = _b[pm2_5:`ceil'.treatment] = 0

estimates restore voc
local port = "Portable" : `: value label treatment'
local ceil = "Ceiling"  : `: value label treatment'
collect psup = r(p) , tags(outcome[voc]) : test _b[voc:`port'.treatment] = _b[voc:`ceil'.treatment] = 0

// Test for noninferiority of portable versus ceiling.
tempname sign

estimates restore pm2_5
nlcom _b[pm2_5:`port'.treatment] - _b[pm2_5:`ceil'.treatment] , post
scalar `sign' = sign(_b[_nl_1])
collect pnon = normal(`sign'*sqrt(r(chi2))) , tags(outcome[pm2_5]) : test _b[_nl_1] = $log_margin

estimates restore voc
nlcom _b[voc:`port'.treatment] - _b[voc:`ceil'.treatment] , post
scalar `sign' = sign(_b[_nl_1])
collect pnon = normal(`sign'*sqrt(r(chi2))) , tags(outcome[voc]) : test _b[_nl_1] = $log_margin

// Label the levels of the outcome dimension.
collect label levels outcome pm2_5 $pm2_5_label voc $voc_label

// Lay out the table.
collect layout (outcome) (treatment#result[mean] treatment[2 3]#result[irr cil ciu] result[psup pnon])

// Style the table.
collect style cell , nformat(%7.2f)
collect style cell result[psup pnon] , nformat(%7.3f)
collect style cell border_block, border(right, pattern(nil))

collect style column , dups(center) // Center duplicated column titles.


collect preview

