data MVCresults;
input z Msmvosd m;
datalines;
1 1 0
;
run;

data tableMVC;
set table;
 format Msmvosd 16.8;
 drop bmratio;
run;

%macro MVC;
%do mon=52 %to 183;
  data MVC1; set tableMVC; if &mon=m then output; run;
  proc rank data=MVC1 out=MVC2 groups=5; var Msmvosd; ranks z2; run;
  proc sort data=MVC2; by z2; run;
  proc rank data=MVC2 out=MVC3 groups=5; var ivol; ranks z1; by z2; run;
  data MVC4; set MVC3; z=z2*5+z1+1; drop z1 z2 ivol; run;
  proc sort data=MVC4; by z; run;
  data MVC4; set MVC4; Msmvosd=log(Msmvosd); run;
  proc summary data=MVC4 nway; class z; var Msmvosd;
    output out=MVC5(drop= _TYPE_ _FREQ_) mean=; run;
  data MVC6; set MVC5; m=&mon; run;
  proc sort data=MVC6; by z; run;
  data MVCresults;
   merge MVC6 MVCresults;
   by m;
  run; 
%end;
quit;
%mend MVC;
%MVC;

data MVCresults;
set MVCresults;
if m=0 then delete;
run;
proc sort data=MVCresults;
by z m;
run;

proc summary data=MVCresults nway;
class z;
var Msmvosd;
output out=ansMVC(drop= _TYPE_ _FREQ_) mean=;
run;
data ansmvc;
 set ansmvc;
 format Msmvosd 16.2;
 Msmvosd=round(Msmvosd,.01);
run;
