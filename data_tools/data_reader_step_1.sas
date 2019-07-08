DATA GTA_SAS.TRD_Dalyr24 (Label="日个股回报率文件");
Infile 'D:\GTA_SAS\TradeCondition\TRD_Dalyr24.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Trddt $10.;
Format Trdsta 10.;
Informat Stkcd $6.;
Informat Trddt $10.;
Informat Trdsta 10.;
Label Stkcd="证券代码";
Label Trddt="交易日期";
Label Trdsta="交易状态";
Input Stkcd $ Trddt $ Trdsta ;
Run;

data GTA_SAS.TRD_Dalyr;
 set GTA_SAS.TRD_Dalyr1-GTA_SAS.TRD_Dalyr24;
run;

proc sort data=GTA_SAS.TRD_Dalyr;
by stkcd Trddt;
run;

DATA GTA_SAS.TRD_Co (Label="公司文件");
Infile 'D:\GTA_SAS\TRD_Co.txt' encoding="utf-8" delimiter = '09'x Missover Dsd lrecl=32767 firstobs=2;
Format Stkcd $6.;
Format Nnindcd $10.;
Informat Stkcd $6.;
Informat Nnindcd $10.;
Label Stkcd="证券代码";
Label Nnindcd="行业代码C";
Input Stkcd $ Nnindcd $ ;
Run;
data GTA_SAS.TRD_Co;
 set GTA_SAS.TRD_Co;
  T=input(substr(left(stkcd),1,1),1.);
  if T=9 or T=2 then delete;
  drop T;
run;


data typePre;
set GTA_SAS.TRD_Dalyr;
  T=input(substr(left(stkcd),1,1),1.);
  if T=9 or T=2 then delete;
  drop T;
run;

data typeByM;/*按月*/
 set typePre;
 year=input(substr(left(Trddt),1,4),4.);
 month=input(substr(left(Trddt),6,2),2.);
 m=(year-2002)*12+month;
 drop year month Trddt;
run;
data typeByM2;
set typeByM;
 if not(Trdsta=1 or Trdsta=4 or Trdsta=7 or Trdsta=10 or Trdsta=13) then 
  output;
run;
data typeByM3;
 set typeByM2;
  drop Trdsta;
run;
proc sort data =typeByM3 out =typeByM4 nodup;
    by stkcd m;
run ;
data typeByM5;
 set typeByM4;
  mNot=1;
run;
data typeByM6;
 merge typeByM5 typeByM;
 by stkcd m;
run;
data typeByM7;
 set typeByM6;
 if mNot=1 then delete;
 drop mNot Trdsta;
run;
proc sort data=typeByM7 out=typeByMonth nodup;
 by stkcd m;
run;


data typeByQ;/*按季度*/
 set typeByM;
   if mod(m,3)=0 then n=m/3;
   if mod(m,3)=1 then n=(m+2)/3;
   if mod(m,3)=2 then n=(m+1)/3;
   drop m;
run;
data typeByQ2;
set typeByQ;
 if not(Trdsta=1 or Trdsta=4 or Trdsta=7 or Trdsta=10 or Trdsta=13) then 
  output;
run;
data typeByQ3;
 set typeByQ2;
  drop Trdsta;
run;
proc sort data =typeByQ3 out =typeByQ4 nodup;
    by stkcd n;
run ;
data typeByQ5;
 set typeByQ4;
  qNot=1;
run;
data typeByQ6;
 merge typeByQ5 typeByQ;
 by stkcd n;
run;
data typeByQ7;
 set typeByQ6;
 if qNot=1 then delete;
 drop qNot Trdsta;
run;
proc sort data=typeByQ7 out=typeByQuarter nodup;
 by stkcd n;
run;
