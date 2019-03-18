drop table if exists deals;

create table deals as
select
  cast(r.tdrnum as INT) as tender_num,

  datetime(o.date, 'unixepoch', 'localtime') as deal_date,
  d.report_date,

  cast(r.period as INT) as period,

  cast(o.camt as REAL) as credit_amount,
  cast(o.ramt as REAL) as return_amount,
  cast(r.rate as REAL) as rate,
  cast(o.camt - o.ramt as REAL) as outstanding,
  datetime(o.rdate, 'unixepoch', 'localtime') as return_date,
  datetime(o.date + r.period * 86400, 'unixepoch', 'localtime') as expiration_date,

  cast(t.ZAmount as REAL) as tender_credit_amount,
  cast(t.CAmount as REAL) as tender_return_amount,
  cast((t.CAmount - t.ZAmount) as REAL) / cast(t.ZAmount as REAL) as tender_interest_rate,

  coalesce(cast(t.CreditAmount as REAL) / cast(t.CreditCnt as REAL), 0) as credit_amount_average,
  coalesce(cast(t.CreditAmount as REAL) / cast(t.CreditCnt as REAL), 0) / cast(t.ZAmount as REAL) as credit_amount_to_average_ratio,

  coalesce(cast(t.CreditCnt as REAL) / cast(t.CreditorsCnt as REAL), 0) as average_repeated_loan_count,

  cast(t.CreditorsCnt as INT) as creditors_count,

  cast(case when o.camt - o.ramt > 0 then (strftime('%s', d.report_date) - o.date)/86400 - r.period
    else (o.rdate - o.date)/86400 - r.period end as INT) as delinq,

  cast(r.rating as INT) as rating,
--  cast(r.r1 as INT) as r1,
--  cast(r.r2 as INT) as r2,
--  cast(r.r3 as INT) as r3,
  cast(r.bl as INT) as business_level,
  coalesce(cast(round((r.creditamount - r.backamount) / r.creditamount * 100, 1) as REAL), 0) as debt,

  coalesce(cast(t.BackCnt as REAL) / cast(t.CreditCnt as REAL), 0) as return_rate,
  coalesce(cast(t.BackAmount as REAL) / cast(t.CreditAmount as REAL), 0) as return_amount_rate,

  cast(t.CreditAmount as REAL) as credit_amount_total,
  cast(t.CreditCnt as REAL) as credit_count_total,

  cast(case when o.date < strftime('%s','2016-06-03') then 'v0' else 'v1' end as TEXT) as model,

  cast(t.RCountryID as INT) as reg_country_id,
  cast(t.RCountry as TEXT) as reg_country,
  cast(t.RCity as TEXT) as reg_city,

  cast(t.PassportDate as TEXT) as pass_date,

  cast(t.Purpose as TEXT) as purpose,
  cast(t.Guarantee as TEXT) as guarantee,
  cast(t.Address as TEXT) as address,
  cast(t.Recomend as TEXT) as recommend,

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
inner join tenders t on t.TenderID = p.CTenderID
inner join (select datetime('2019-03-12 20:00:00') as report_date) d;
