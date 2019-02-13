/*
  correlation
*/
select
--debt > 0 as debt_y, count(debt), sum(camt) 
--creditamount > 40000 as cr, count(camt), sum(camt) 
delinq,rating, r1, r2, r3, bl, debt, outstanding, creditamount
from deals
where date > strftime('%s','2016-06-03') -- rating model v1
and strftime('%s','now') - date - period * 86400 > 0 -- matured
and outstanding > 0
and delinq > 90
--group by cr