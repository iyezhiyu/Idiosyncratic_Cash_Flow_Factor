/*-------现金流描述--------*/
data CFmiaoshu;
 set netcashflow2;
run;
proc sort data=CFmiaoshu;
by n stkcd;
run;
proc means data=CFmiaoshu noprint;
by n;
output out=CFmiaoshu2;
run;
data CFshuliang;
 set CFmiaoshu2;
 if _STAT_='N';
run;
data CFmean;
 set CFmiaoshu2;
 if _STAT_='MEAN';
run;
data CFstd;
 set CFmiaoshu2;
 if _STAT_='STD';
run;
proc univariate data=CFmiaoshu noprint;
by n;
var netcashflow;
output out=CFmiaoshu3 pctlpts=0 1 25 50 75 99 100 pctlpre=a_ ;
run;


/*-------增长率--------*/
data gmiaoshu;
 set gcashflow2;
run;
proc sort data=gmiaoshu;
by n;
run;
proc means data=gmiaoshu noprint;
by n;
output out=gmiaoshu2;
run;
data gshuliang;
 set gmiaoshu2;
 if _STAT_='N';
run;
data gmean;
 set gmiaoshu2;
 if _STAT_='MEAN';
run;
data gstd;
 set gmiaoshu2;
 if _STAT_='STD';
run;
proc univariate data=gmiaoshu noprint;
by n;
var g;
output out=gmiaoshu3 pctlpts=0 1 25 50 75 99 100 pctlpre=a_ ;
run;

/*-------IVOL描述--------*/
data ivolmiaoshu;
 set cashflowaver5;
run;
proc sort data=ivolmiaoshu;
by n;
run;
proc means data=ivolmiaoshu noprint;
by n;
output out=ivolmiaoshu2;
run;
data ivolshuliang;
 set ivolmiaoshu2;
 if _STAT_='N';
run;
data ivolmean;
 set ivolmiaoshu2;
 if _STAT_='MEAN';
run;
data ivolstd;
 set ivolmiaoshu2;
 if _STAT_='STD';
run;
proc univariate data=ivolmiaoshu noprint;
by n;
var ivol;
output out=ivolmiaoshu3 pctlpts=0 1 25 50 75 99 100 pctlpre=a_ ;
run;
