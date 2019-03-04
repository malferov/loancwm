/*
  denormalized deals source
  TODO add rate to the deals source
*/
drop table if exists deals;
create TEMP table deals as
select cast(o.date as INT) as odate,
datetime(o.date, 'unixepoch', 'localtime') as dealdate,
cast(r.period as INT) as period,
cast(o.camt as REAL) as camt,
cast(o.ramt as REAL) as ramt,
cast(o.camt-o.ramt as REAL) as outstanding,
datetime(o.rdate, 'unixepoch', 'localtime') as returndate,
cast(o.date + r.period * 86400 as INT) as mdate,
datetime(o.date + r.period * 86400, 'unixepoch', 'localtime') as maturitydate, 
cast(case when o.camt - o.ramt > 0 then (strftime('%s','now') - o.date)/86400 - r.period
else (o.rdate - o.date)/86400 - r.period end as INT) as delinq,
cast(r.rating as INT) as rating,
cast(r.r1 as INT) as r1,
cast(r.r2 as INT) as r2,
cast(r.r3 as INT) as r3,
cast(r.bl as INT) as bl,
cast(round((r.creditamount - r.backamount) / r.creditamount * 100, 1) as REAL) as debt,
cast(r.creditamount as REAL) as creditamount,
case when o.date < strftime('%s','2016-06-03') then 'v0' else 'v1' end model
from operation o
inner join portfolio p on p.CDWMTranID = o.id
inner join rating r on r.tdrnum = p.CTenderID;

/*
  delinquency group by active, overdue, delinq_60, delinq_360, delinq_def
*/
drop table if exists delinq;
create TEMP table delinq as
select sum(outstanding) as outstanding,
sum(ramt) as paid,
outstanding > 0 as active,
delinq > 0   as overdue, 
delinq > 0   and delinq <= 60 as delinq_60,
delinq > 60  and delinq <= 360 as delinq_360,
delinq > 360 as delinq_def
from deals
group by active, overdue, delinq_60, delinq_360, delinq_def;

select *,
round(outstanding * 100 / (select sum(outstanding) from delinq), 0) as ratio_delinq,
round(paid * 100 / (select sum(paid) from delinq where outstanding <= 0), 1) as ratio_paid
from delinq;

/*
  overall delinquency
*/
drop table if exists overall;
create TEMP table overall as
select sum(camt) as credit,
delinq > 0   as overdue, 
delinq > 0   and delinq <= 60 as delinq_60,
delinq > 60  and delinq <= 360 as delinq_360,
delinq > 360 as delinq_def
from deals
group by overdue, delinq_60, delinq_360, delinq_def;

select *,
round(credit * 100 / (select sum(credit) from overall), 0) as ratio
from overall;
