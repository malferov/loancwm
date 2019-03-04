/*
  denormalized deals source
*/
drop table if exists deals;
create TEMP table deals as
select cast(o.date as INT) as odate,
datetime(o.date, 'unixepoch', 'localtime') as dealdate,
cast(r.period as INT) as period,
cast(o.camt as REAL) as camt,
cast(o.ramt as REAL) as ramt,
cast(r.rate as REAL) as rate,
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