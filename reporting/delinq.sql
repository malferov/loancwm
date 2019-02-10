/*
  denormalized deals source
*/
drop table if exists deals;
create TEMP table deals as
select o.date, datetime(o.date, 'unixepoch', 'localtime') as dealdate, 
r.period, o.camt, o.ramt, o.camt-o.ramt as outstanding,
o.rdate, datetime(o.rdate, 'unixepoch', 'localtime') as returndate,
datetime(o.date + r.period * 86400, 'unixepoch', 'localtime') as maturitydate, 
case when o.camt - o.ramt > 0 then (strftime('%s','now') - o.date)/86400 - r.period
else (o.rdate - o.date)/86400 - r.period end delinq
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