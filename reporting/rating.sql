/*
  correlation
*/
select
creditamount = 0 as cr0,
creditamount > 0 and creditamount <= 1000 as cr1,
creditamount > 1000 and creditamount <= 2000 as cr2,
creditamount > 2000 and creditamount <= 3000 as cr3,--32815
creditamount > 3000 and creditamount <= 4000 as cr4,
creditamount > 4000 and creditamount <= 5000 as cr5,
debt = 0 as debt0,
count(camt), sum(camt), sum(outstanding)
--delinq, rating, r1, r2, r3, bl, debt, outstanding, creditamount
from deals
where model = 'v1'
and strftime('%s','now') - mdate > 0 -- matured
and outstanding > 0
and delinq > 90
--order by cast(creditamount as decimal)
group by cr0, cr1, cr2, cr3, cr4, cr5, debt0
