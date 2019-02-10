/*
  denormalized source
*/
drop table if exists correlation;
create TEMP table correlation as
select 
case when o.camt - o.ramt > 0 then (strftime('%s','now') - o.date)/86400 - r.period
else (o.rdate - o.date)/86400 - r.period end delinq,
r.rating, r.r1, r.r2, r.r3
from operation o
inner join portfolio p on p.CDWMTranID = o.id
inner join rating r on r.tdrnum = p.CTenderID
where r.rating < 1000 and
o.date > strftime('%s','2016-06-03') and -- the last rating model change
strftime('%s','now') - o.date - r.period * 86400 > 0;

select * from correlation;
