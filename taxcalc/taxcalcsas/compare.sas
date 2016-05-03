%INCLUDE "taxcalc.sas";
proc import datafile="compare-in.csv" out=indata dbms=csv; getnames=yes;
run;
data outdata;
set indata;
%INIT;
* NOTE: _cmbtp is set to zero in INIT even though _puf==1 because f6251==0;
_puf = 0;
_agep = age_head;
_ages = age_spouse;
_numxtr = 0; * specify number of taxpayers who are age 65+;
if _agep ge 65 then _numxtr = _numxtr + 1;
if _ages ge 65 then _numxtr = _numxtr + 1;
e19400 = e19200; * rename non-AMT-preferred deductions because _puf is zero;
e32700 = e32800; * rename childcare expenses because _puf is zero;
e32880 = e00200p; * rename taxpayer earnings for childcare credit logic;
e32890 = e00200s; * rename spouse earnings for childcare credit logic;
%COMP;
_nbertax = _nbertax + c07200; * ignore Sch.R credit not in Tax-Calculator;
keep RECID c00100 c02500 c04600 c04470 c04800 c05200 c05800
     c07180 c07220 c09600 c11070 c21040 c59660 _nbertax;
proc export data=outdata outfile="compare-out.csv" dbms=csv replace;
run;
