select *
from deals
where not (
  outstanding > 0 -- there is an active debt
  and report_date < datetime(expiration_date, '+365 day') -- non matured + small delinquency
)
