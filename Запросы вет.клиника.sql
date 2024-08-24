/* Найти назначения, которые привели к смерти наибольшее количество раз. 
Если два из каких-то назначений привели к смерти одинаковое количество раз, 
то выводятся оба */

with death_counts as (
  select s.name_, count(*) as death_count
  from service s
  join service_to_inpatient_treatment stit on s.service_id = stit.service_id
  join inpatient_treatment it on stit.inpatient_treatment_id = it.inpatient_treatment_id
  where it.effectiveness = false
  group by s.name_
)
select name_
from death_counts
where death_count = (select max(death_count) from death_counts);

/* Вывести питомцев, которые принесли клинике в денежном выражении больше 30 процентов */

with total_revenue as (
  select sum(b.cost_) as total_cost
  from bill b
),
top_30_percent_pets as (
  select p.pet_id, p.nickname, sum(b.cost_) as pet_revenue
  from pet p
  join pet_to_appointment pta on p.pet_id = pta.pet_id
  join appointment a on pta.appointment_id = a.appointment_id
  join service_to_appointment sta on a.appointment_id = sta.appointment_id
  join service s on sta.service_id = s.service_id
  join bill_to_service bts on s.service_id = bts.service_id
  join bill b on bts.bill_id = b.bill_id
  group by p.pet_id, p.nickname
  having sum(b.cost_) >= (select 0.3 * total_cost from total_revenue)
)
select *
from top_30_percent_pets
order by pet_revenue desc;















