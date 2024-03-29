data MVBresults;
input z return m;
datalines;
1 1 0
;
run;

data tableMVB;
set table;
 drop bmratio;
run;

%macro MVB;
%do mon=52 %to 183;
  data MVB1; set tableMVB; if &mon=m then output; run;
  proc rank data=MVB1 out=MVB2 groups=10; var ivol; ranks z; run;
  proc sort data=MVB2; by z; run;
  data MVB4; set MVB2; z=z+1;drop ivol;run;
  proc univariate data=MVB4 noprint; var Mretwd; by z;
     output out=MVB5 mean=return;run;
  data MVB6; set MVB5; m = &mon; run;
  data MVB7;
  set MVB6;
    output;
	if z=1 then do r1=return; retain r1; end;
    if z=10 then do z=11;return=return-r1;output;end;
  run;
  data MVB8; set MVB7; drop r1; run;
  proc sort data=MVB8; by z; run;
  data MVBresults; merge MVB8 MVBresults; by m; run;
%end;
quit;
%mend MVB;
%MVB;

data MVBresults;/*用于以下三个表格*/
set MVBresults;
if m=0 then delete;
run;
proc sort data=MVBresults;
by z m;
run;

/*------------------回报率表格-------------------*/
data origin; set MVBresults; drop m; run;
proc reg data=origin outest=origin2 tableout noprint;
 by z;
 model return =;
run;
data origin3;
set origin2;
 if not(_TYPE_='PARMS' or _TYPE_='T') then delete;
 keep z intercept;
run;
data origin3;
 set origin3;
 by z;
 if first.z then intercept=intercept*100;
run;
data origin3_1; set origin3; if mod(z,10)=1 and z^=11; lie1=intercept;drop z intercept;run;
data origin3_2; set origin3; if mod(z,10)=2; lie2=intercept;drop z intercept;run;
data origin3_3; set origin3; if mod(z,10)=3; lie3=intercept;drop z intercept;run;
data origin3_4; set origin3; if mod(z,10)=4; lie4=intercept;drop z intercept;run;
data origin3_5; set origin3; if mod(z,10)=5; lie5=intercept;drop z intercept;run;
data origin3_6; set origin3; if mod(z,10)=6; lie6=intercept;drop z intercept;run;
data origin3_7; set origin3; if mod(z,10)=7; lie7=intercept;drop z intercept;run;
data origin3_8; set origin3; if mod(z,10)=8; lie8=intercept;drop z intercept;run;
data origin3_9; set origin3; if mod(z,10)=9; lie9=intercept;drop z intercept;run;
data origin3_10; set origin3; if mod(z,10)=0; lie10=intercept;drop z intercept;run;
data origin3_11; set origin3; if z=11;
      lie11=intercept;drop z intercept;run;
data ansorigin;
 merge origin3_1 - origin3_11;
 format lie1-lie11 6.2;
run;

/*------------------CAPM表格-------------------*/
data capm; set MVBresults; run;
proc sort data=capm; by m; run;
data capm1; merge capm factors; by m; run;
data capm2;
set capm1;
 if missing(return) then delete;
 drop smb hml umd rmw cma smb_equal hml_equal umd_equal rmw_equal cma_equal;
run;
proc sort data=capm2; by z m; run;
data capm3;
set capm2;
 return=return-rf;
 drop rf m;
run;
proc reg data=capm3 outest=capm4 tableout noprint;
model return = mkt_rf;
by z;
run;
data capm5;
set capm4;
 if not(_TYPE_='PARMS' or _TYPE_='T') then delete;
 keep z intercept;
run;
data capm6;
 set capm5;
 by z;
 if first.z then intercept=intercept*100;
run;
data capm6_1; set capm6; if mod(z,10)=1 and z^=11; lie1=intercept;drop z intercept;run;
data capm6_2; set capm6; if mod(z,10)=2; lie2=intercept;drop z intercept;run;
data capm6_3; set capm6; if mod(z,10)=3; lie3=intercept;drop z intercept;run;
data capm6_4; set capm6; if mod(z,10)=4; lie4=intercept;drop z intercept;run;
data capm6_5; set capm6; if mod(z,10)=5; lie5=intercept;drop z intercept;run;
data capm6_6; set capm6; if mod(z,10)=6; lie6=intercept;drop z intercept;run;
data capm6_7; set capm6; if mod(z,10)=7; lie7=intercept;drop z intercept;run;
data capm6_8; set capm6; if mod(z,10)=8; lie8=intercept;drop z intercept;run;
data capm6_9; set capm6; if mod(z,10)=9; lie9=intercept;drop z intercept;run;
data capm6_10; set capm6; if mod(z,10)=0; lie10=intercept;drop z intercept;run;
data capm6_11; set capm6; if z=11;
      lie11=intercept;drop z intercept;run;
data anscapm;
 merge capm6_1 - capm6_11;
 format lie1-lie11 6.2;
run;

/*------------------法玛三因子表格-------------------*/
data ff;set MVBresults;run;
proc sort data=ff;by m;run;
data ff1;merge ff factors;by m;run;
data ff2;set ff1;
 if missing(return) then delete;
 drop umd rmw cma smb_equal hml_equal umd_equal rmw_equal cma_equal;
run;
data ff3;set ff2;return=return-rf;drop rf;run;
proc sort data=ff3;by z m;run;

proc reg data=ff3 outest=ff4 tableout noprint;
model return = mkt_rf smb hml;
by z;
run;
data ff5; set ff4; if not(_TYPE_='PARMS' or _TYPE_='T') then delete; run;
data ff6; set ff5; keep z intercept; run;
data ff7; set ff6;
 by z; if first.z then intercept=intercept*100;
run;
data ff7_1; set ff7; if mod(z,10)=1 and z^=11; lie1=intercept;drop z intercept;run;
data ff7_2; set ff7; if mod(z,10)=2; lie2=intercept;drop z intercept;run;
data ff7_3; set ff7; if mod(z,10)=3; lie3=intercept;drop z intercept;run;
data ff7_4; set ff7; if mod(z,10)=4; lie4=intercept;drop z intercept;run;
data ff7_5; set ff7; if mod(z,10)=5; lie5=intercept;drop z intercept;run;
data ff7_6; set ff7; if mod(z,10)=6; lie6=intercept;drop z intercept;run;
data ff7_7; set ff7; if mod(z,10)=7; lie7=intercept;drop z intercept;run;
data ff7_8; set ff7; if mod(z,10)=8; lie8=intercept;drop z intercept;run;
data ff7_9; set ff7; if mod(z,10)=9; lie9=intercept;drop z intercept;run;
data ff7_10; set ff7; if mod(z,10)=0; lie10=intercept;drop z intercept;run;
data ff7_11; set ff7; if z=11;
      lie11=intercept;drop z intercept;run;
data ansff;
 merge ff7_1 - ff7_11;
 format lie1-lie11 6.2;
run;

data ansall;
 set ansorigin anscapm ansff;
run;


/*-----------------------------年度-------------------*/
data nianduMVBresults;
set MVBresults;
if m>=181 and m<=183 ;
run;


data origin; set nianduMVBresults; drop m; run;
proc reg data=origin outest=origin2 tableout noprint;
 by z;
 model return =;
run;
data origin3;
set origin2;
 if not(_TYPE_='PARMS' or _TYPE_='T') then delete;
 keep z intercept;
run;
data origin3;
 set origin3;
 by z;
 if first.z then intercept=intercept*100;
run;
data origin3_1; set origin3; if mod(z,10)=1 and z^=11; lie1=intercept;drop z intercept;run;
data origin3_2; set origin3; if mod(z,10)=2; lie2=intercept;drop z intercept;run;
data origin3_3; set origin3; if mod(z,10)=3; lie3=intercept;drop z intercept;run;
data origin3_4; set origin3; if mod(z,10)=4; lie4=intercept;drop z intercept;run;
data origin3_5; set origin3; if mod(z,10)=5; lie5=intercept;drop z intercept;run;
data origin3_6; set origin3; if mod(z,10)=6; lie6=intercept;drop z intercept;run;
data origin3_7; set origin3; if mod(z,10)=7; lie7=intercept;drop z intercept;run;
data origin3_8; set origin3; if mod(z,10)=8; lie8=intercept;drop z intercept;run;
data origin3_9; set origin3; if mod(z,10)=9; lie9=intercept;drop z intercept;run;
data origin3_10; set origin3; if mod(z,10)=0; lie10=intercept;drop z intercept;run;
data origin3_11; set origin3; if z=11;
      lie11=intercept;drop z intercept;run;
data ansorigin;
 merge origin3_1 - origin3_11;
 format lie1-lie11 6.2;
run;


data capm; set nianduMVBresults; run;
proc sort data=capm; by m; run;
data capm1; merge capm factors; by m; run;
data capm2;
set capm1;
 if missing(return) then delete;
 drop smb hml umd rmw cma smb_equal hml_equal umd_equal rmw_equal cma_equal;
run;
proc sort data=capm2; by z m; run;
data capm3;
set capm2;
 return=return-rf;
 drop rf m;
run;
proc reg data=capm3 outest=capm4 tableout noprint;
model return = mkt_rf;
by z;
run;
data capm5;
set capm4;
 if not(_TYPE_='PARMS' or _TYPE_='T') then delete;
 keep z intercept;
run;
data capm6;
 set capm5;
 by z;
 if first.z then intercept=intercept*100;
run;
data capm6_11; set capm6; if z=11;
      lie12=intercept;drop z intercept;run;
data anscapm;
 set capm6_11;
 format lie12 6.2;
run;


data ff;set nianduMVBresults;run;
proc sort data=ff;by m;run;
data ff1;merge ff factors;by m;run;
data ff2;set ff1;
 if missing(return) then delete;
 drop umd rmw cma smb_equal hml_equal umd_equal rmw_equal cma_equal;
run;
data ff3;set ff2;return=return-rf;drop rf;run;
proc sort data=ff3;by z m;run;

proc reg data=ff3 outest=ff4 tableout noprint;
model return = mkt_rf smb hml;
by z;
run;
data ff5; set ff4; if not(_TYPE_='PARMS' or _TYPE_='T') then delete; run;
data ff6; set ff5; keep z intercept; run;
data ff7; set ff6;
 by z; if first.z then intercept=intercept*100;
run;
data ff7_11; set ff7; if z=11;
      lie13=intercept;drop z intercept;run;
data ansff;
 set ff7_11;
 format lie13 6.2;
run;

data ansall;
 merge ansorigin anscapm ansff;
run;
