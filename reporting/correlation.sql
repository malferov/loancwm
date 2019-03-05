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
creditamount > 5000 and creditamount <= 6000 as cr6,
creditamount > 6000 and creditamount <= 7000 as cr7,
creditamount > 7000 and creditamount <= 8000 as cr8,
creditamount > 8000 and creditamount <= 9000 as cr9,
creditamount > 9000 and creditamount <= 10000 as cr10,
creditamount > 10000 and creditamount <= 20000 as cr20,
creditamount > 20000 and creditamount <= 50000 as cr50,
creditamount > 50000 and creditamount <= 100000 as cr100,
--debt = 0 as debt0,
count(camt), sum(camt), sum(outstanding)
--select delinq, rating, r1, r2, r3, bl, debt, outstanding, creditamount
from deals
where model = 'v1'
and strftime('%s','now') - mdate > 0 -- matured
and outstanding > 0
and delinq > 90
--order by cast(creditamount as decimal)
group by cr0, cr1, cr2, cr3, cr4, cr5, cr6, cr7, cr8, cr9, cr10, cr20, cr50, cr100--, debt0
