DATA GTA_SAS.FS_Comins (Label="利润表");
Infile 'D:\GTA_SAS\FS_Comins.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format B002000000 20.;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat B002000000 20.;
Label Stkcd="证券代码";
Label Accper="会计期间";
Label Typrep="报表类型";
Label B002000000="净利润";
Input Stkcd $ Accper $ Typrep $ B002000000 ;
Run;
data profitPre;
set GTA_SAS.FS_Comins;
  T=input(substr(left(stkcd),1,1),1.);
  if T=9 or T=2 then delete;
  drop T;
run;
data profit;
 set profitPre;
 if Typrep='A';
 year=input(substr(left(Accper),1,4),4.);
 month=input(substr(left(Accper),6,2),2.);
 if month=1 then delete;
 quarter=month/3;
 n=(year-2002)*4+quarter;
 drop Typrep year month quarter Accper;
run;
proc sort data=profit;
by stkcd n;
run;
data profit2;
 set profit;
 lagB002000000=lag(B002000000);
 lagn=lag(n);
run;
data profit3;
 set profit2;
 by stkcd;
 if mod(n,4)=1 then profit=B002000000;
 if first.stkcd=0 and mod(n,4)^=1 then do;
      if lagn=(n-1) then profit=B002000000-lagB002000000;
 end;
run;
data profit4;
 set profit3;
  drop B002000000 lagB002000000 lagn;
run;


/*☆☆☆☆☆☆☆☆☆☆BEGIN-----去除金融类-----按季度*/
data D_Finance;
  set GTA_SAS.TRD_Co;
  if substr(Nnindcd,1,1)='J' then NotAvail=1;
run;
data profit4;
 merge profit4 D_Finance;
 by stkcd;
run;
data profit4;
 set profit4;
 if missing(NotAvail)=0 then delete;
 drop NotAvail Nnindcd;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----去除金融类-----按季度*/

/*☆☆☆☆☆☆☆☆☆☆BEGIN-----数据描述用--同时去除ST和金融-----按季度*/
data D_Finance;
  set GTA_SAS.TRD_Co;
  if substr(Nnindcd,1,1)='J' then NotAvail=1;
run;
data profit4;
 merge profit4 D_Finance;
 by stkcd;
run;
data profit4;
 set profit4;
 if missing(NotAvail)=0 then delete;
 drop NotAvail Nnindcd;
run;
data D_ST;
  set typeByQuarter;
  Avail=1;
run;
data D_ST_Finance;
 merge D_ST D_Finance;
 by stkcd;
run;
data D_ST;
 set D_ST_Finance;
  if substr(Nnindcd,1,1)='J' then delete;
  drop NotAvail Nnindcd;
run;
data profit4;
 merge profit4 D_ST;
 by stkcd n;
 if missing(Avail) then delete;
 drop Avail;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----数据描述用--同时去除ST和金融-----按季度*/

/*☆☆☆☆☆☆☆☆☆☆BEGIN-----去除ST-----按季度*/
data D_ST;
  set typeByQuarter;
  Avail=1;
run;
data profit4;
 merge profit4 D_ST;
 by stkcd n;
 if missing(Avail) then delete;
 drop Avail;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----去除ST-----按季度*/


DATA GTA_SAS.FS_Comscfi (Label="现金流量表（间接法）");
Infile 'D:\GTA_SAS\FS_Comscfi.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Accper $10.;
Format Typrep $1.;
Format D000103000 20.;
Format D000104000 20.;
Format D000105000 20.;
Informat Stkcd $6.;
Informat Accper $10.;
Informat Typrep $1.;
Informat D000103000 20.;
Informat D000104000 20.;
Informat D000105000 20.;
Label Stkcd="证券代码";
Label Accper="会计期间";
Label Typrep="报表类型";
Label D000103000="固定资产折旧、油气资产折耗、生产性生物资产折旧";
Label D000104000="无形资产摊销";
Label D000105000="长期待摊费用摊销";
Input Stkcd $ Accper $ Typrep $ D000103000 D000104000 D000105000 ;
Run;
data depreciationPre;
set GTA_SAS.FS_Comscfi;
  T=input(substr(left(stkcd),1,1),1.);
  if T=9 or T=2 then delete;
  drop T;
run;

data depreciation;/*生成现金流*/
set depreciationPre;
  if Typrep='A';
  if missing(D000103000) then D000103000=0;
  if missing(D000104000) then D000104000=0;
  if missing(D000105000) then D000105000=0;
  depreciation=D000103000+D000104000+D000105000;
  year=input(substr(left(Accper),1,4),4.);
  month=input(substr(left(Accper),6,2),2.);
  if month=1 then delete;
  quarter=month/3;
  n=(year-2002)*4+quarter;
  drop Typrep D000103000 D000104000 D000105000 year quarter month Accper;
run;
data netdepreciation;
 set depreciation;
 if mod(n,2)=1 then delete;
run;
proc sort data=netdepreciation;
by stkcd n;
run;
data netdepreciation2;
 set netdepreciation;
  lagn=lag(n);
  lagdepre=lag(depreciation);
run;
data netdepreciation3;
set netdepreciation2;
by stkcd;
if first.stkcd and mod(n,4)=2 then do;
	     m=n-1;netdepreciation=depreciation/2;output;
         m=n;netdepreciation=depreciation/2;output;
end;
if first.stkcd and mod(n,4)=0 then do;
	     m=n-3;netdepreciation=depreciation/4;output;
         m=n-2;netdepreciation=depreciation/4;output;
	     m=n-1;netdepreciation=depreciation/4;output;
         m=n;netdepreciation=depreciation/4;output;
end;
if first.stkcd=0 and mod(n,4)=2 then do;
	     m=n-1;netdepreciation=depreciation/2;output;
         m=n;netdepreciation=depreciation/2;output;
end;
if (first.stkcd=0) and (mod(n,4)=0) and ((lagn = (n-2))) then do;
	        m=n-1;netdepreciation=(depreciation-lagdepre)/2;output;
		    m=n;netdepreciation=(depreciation-lagdepre)/2;output;
end;
if (first.stkcd=0) and (mod(n,4)=0) and ((lagn ^= (n-2))) then do;
	        m=n-3;netdepreciation=depreciation/4;output;
            m=n-2;netdepreciation=depreciation/4;output;
	        m=n-1;netdepreciation=depreciation/4;output;
            m=n;netdepreciation=depreciation/4;output;
end;
run;
data netdepreciation4;
 set netdepreciation3;
 n=m;
 drop m lagn lagdepre depreciation;
run;


/*☆☆☆☆☆☆☆☆☆☆BEGIN-----去除金融类-----按季度*/
data D_Finance;
  set GTA_SAS.TRD_Co;
  if substr(Nnindcd,1,1)='J' then NotAvail=1;
run;
data netdepreciation4;
 merge netdepreciation4 D_Finance;
 by stkcd;
run;
data netdepreciation4;
 set netdepreciation4;
 if missing(NotAvail)=0 then delete;
 drop NotAvail Nnindcd;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----去除金融类-----按季度*/

/*☆☆☆☆☆☆☆☆☆☆BEGIN-----数据描述用--同时去除ST和金融-----按季度*/
data D_Finance;
  set GTA_SAS.TRD_Co;
  if substr(Nnindcd,1,1)='J' then NotAvail=1;
run;
data netdepreciation4;
 merge netdepreciation4 D_Finance;
 by stkcd;
run;
data netdepreciation4;
 set netdepreciation4;
 if missing(NotAvail)=0 then delete;
 drop NotAvail Nnindcd;
run;
data D_ST;
  set typeByQuarter;
  Avail=1;
run;
data D_ST_Finance;
 merge D_ST D_Finance;
 by stkcd;
run;
data D_ST;
 set D_ST_Finance;
  if substr(Nnindcd,1,1)='J' then delete;
  drop NotAvail Nnindcd;
run;
data netdepreciation4;
 merge netdepreciation4 D_ST;
 by stkcd n;
 if missing(Avail) then delete;
 drop Avail;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----数据描述用--同时去除ST和金融-----按季度*/

/*☆☆☆☆☆☆☆☆☆☆BEGIN-----去除ST-----按季度*/
data D_ST;
  set typeByQuarter;
  Avail=1;
run;
data netdepreciation4;
 merge netdepreciation4 D_ST;
 by stkcd n;
 if missing(Avail) then delete;
 drop Avail;
run;
/*☆☆☆☆☆☆☆☆☆☆END-----去除ST-----按季度*/


data netcashflow;/*生成净现金流*/
merge netdepreciation4 profit4;
by stkcd n;
run;
data netcashflow2;
set netcashflow;
  netcashflow=netdepreciation+profit;
  drop netdepreciation profit;
run;

data gcashflow;
input n stkcd $;
datalines;
0 '000000'
;
run;

%macro gcashflow;
%do t=5 %to 61;/*2002年到2017年第一季度共61个季度*/
   data g1; set netcashflow2; if n=&t-4 then output; run;
   data g1; set g1; netcashflow1=netcashflow; drop netcashflow; run;
   data g2; set netcashflow2; if n=&t then output; run;
   data g2; set g2; netcashflow2=netcashflow; drop netcashflow; run;
   data g3; merge g1 g2; by stkcd; run;
   proc sort data=g3; by stkcd n; run;
   data gcashflow; merge g3 gcashflow; by stkcd n; run;
%end;
%mend gcashflow;
%gcashflow;

data gcashflow2;/*得到现金流增长率*/
 set gcashflow;
 if n=0 then delete;
 if (netcashflow1>0) and (netcashflow2>=0) then
    g= (netcashflow2-netcashflow1)/netcashflow1;
 drop netcashflow1 netcashflow2;
 run;

data gcashflow3;/*开始计算IVOL*/
 set gcashflow2;
  if missing(g) then delete;
run;
proc sort data=gcashflow3;
by stkcd n;
run;

data cashflowaver / view=cashflowaver;
  array _X {100} _temporary_ ;
  array _H {100} _temporary_ ;
  set gcashflow3;
  by stkcd;
  retain NN 0;
  NN = ifn(first.stkcd,1,NN+1);
  _X{NN}=g;
  _H{NN}=n;
  do I= 1 to NN-1;
    if n-_H{I}<25 then do
        gg=_X{I};
		gt=_H{I};
	    output;
    end;
  end;  
run;

data cashflowaver2;
 set cashflowaver;
 if mod(n-gt,4) ^= 0 then delete;
 drop gt NN I;
run;
proc means data=cashflowaver2 noprint nway missing;
class stkcd n;
var g gg;
output out=cashflowaver3 mean=;
run;
data cashflowaver4;
 set cashflowaver3;
   if _FREQ_<3 then delete;
   drop _TYPE_ _FREQ_;
run;
data cashflowaver5;
 set cashflowaver4;
 IVOL=g-gg;
 drop g gg;
run;
data IVOL;
 set cashflowaver5;
 m=n*3+1;output;
 m=m+1;output;
 m=m+1;output;
 drop n;
run;
proc sort data=IVOL;
by m stkcd;
run;
