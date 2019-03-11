drop table if exists deals;

create table deals as
select
  cast(r.tdrnum as INT) as tender_num,
  cast(o.date as INT) as dea_date,
  datetime(o.date, 'unixepoch', 'localtime') as deal_date,
  cast(r.period as INT) as period,
  cast(o.camt as REAL) as credit_amount,
  cast(o.ramt as REAL) as return_amount,
  cast(r.rate as REAL) as rate,
  cast(o.camt-o.ramt as REAL) as outstanding,
  datetime(o.rdate, 'unixepoch', 'localtime') as return_date,
  cast(o.date + r.period * 86400 as INT) as exp_date,
  datetime(o.date + r.period * 86400, 'unixepoch', 'localtime') as expiration_date,
  cast(case when o.camt - o.ramt > 0 then (strftime('%s','now') - o.date)/86400 - r.period
    else (o.rdate - o.date)/86400 - r.period end as INT) as delinq,
  cast(r.rating as INT) as rating,
--  cast(r.r1 as INT) as r1,
--  cast(r.r2 as INT) as r2,
  cast(r.r3 as INT) as r3,
  cast(r.bl as INT) as business_level,
  coalesce(cast(round((r.creditamount - r.backamount) / r.creditamount * 100, 1) as REAL), 0) as debt,
  cast(r.creditamount as REAL) as credit_amount_total,
  cast(case when o.date < strftime('%s','2016-06-03') then 'v0' else 'v1' end as TEXT) as model,
  cast(t.RCountryID as INT) as reg_country_id,
  cast(t.RCountry as TEXT) as reg_country,

  cast(o.wmid as TEXT) as wmid,

  (
    select count(*)
    from operation
    where wmid = o.wmid and datetime(date, 'unixepoch', 'localtime') < datetime(o.date, 'unixepoch', 'localtime')
  ) as loan_count,

  (
    select count(*)
    from operation
    where wmid = o.wmid
  ) as loan_count_total

from operation o
inner join portfolio p on p.CDWMTranID = o.id
inner join rating r on r.tdrnum = p.CTenderID
inner join tenders t on t.TenderID = p.CTenderID;