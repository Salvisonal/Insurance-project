Create database Insurence;
use Insurence; 
-- 1. No of Invoice --
select branch_name,count(`Account Executive`) as `Total No of Invoices`
from invoice
group by branch_name;

-- 2.Yearly Meeting Count --
Select Year, count(meeting_date)
as `No of meetings` from meeting
group by year;


-- 3. No of meeting By Account Executive --
Select `ï»¿Account Executive` as `Account Executive`, 
count(meeting_date) as `Year meeting count`
from meeting
group by `ï»¿Account Executive`;

-- 4. No of Invoice by Account Executive --  
Select `Account Executive`, 
count(ï»¿invoice_number) as ` No of Invoice`
from invoice
group by `Account Executive`
order by `No of invoice` desc;

-- 5. No of Global Meeting
select Year, count(global_attendees) as `No of global meeting` From meeting
where global_attendees <> 'NA'
group by year;


-- 6. No of Gobal meeting 
select `ï»¿Account Executive` as `Account Executive`, count(global_attendees) as `No of global meetings`
from meeting
where global_attendees <> 'NA'
group by `ï»¿Account Executive`
order by `No of global meetings` desc;

-- 7. Created views 
Create view Traget as
select 'New' as Type, concat(Round(Sum(`New Budget`)/1000000,2), "M") as ToTal from `individual budgets`
UNION ALL
select 'Cross sell', concat(Round(Sum(`Cross sell bugdet`)/1000000,2), "M") from `individual budgets`
union all 
select 'Renewal', concat(Round(Sum(`Renewal Budget`)/1000000,2), "M") as Renewal from `individual budgets`;

Select * from Traget ;

-- 8.create view New
create view New as 
select income_class, concat(Round(Sum(Amount)/1000000,2), "M") as Total from invoice
Where income_class <> '0'
group by income_class
;

Select * from New;

-- 9. brokerage + Fees
Create View `Placed Achievement` as  
Select `Account Executive`,branch_name,income_class,Amount,income_due_date from brokerage
union all
select `Account Executive`,branch_name,income_class,Amount,income_due_date from fees
;
 
Select * from `Placed Achievement`;

-- 10. Create View Achive
Create View Achive as
select income_class, concat(Round(Sum(Amount)/1000000,2), "M") as Aamout from `Placed Achievement`
Where income_class <> 'NA'
group by income_class
; 

select *from Achive;
 
-- 11. Target vs Achieved vs New
Select T.Type, concat(sum(T.ToTal), "M") as Traget, 
concat(Sum(A.Aamout), "M") as Achive,
Concat(Sum(N.Total), "M") as New
from traget t
Join new n
On T.Type = N.income_class
join achive a
on N.income_class = A.income_class
group by Type;

-- 12. Percentage of Achievement
Select concat(Round(sum(A.Aamout)/sum(T.ToTal),2), "%") as `Percentage of Achievement`
From Traget t
join achive a
on T.Type = A.income_class;


-- 13. Stage Funnel by Revenue
select stage,concat(Round(sum(revenue_amount)/ 1000000,2), "M") 
as Total_Revenue
from opportunity
group by stage
order by Total_Revenue DESC;

-- 14. Top 5 Open Opportunities (by Revenue)
SELECT 
    `ï»¿opportunity_name` As `Opportunity Name` ,
    concat(Round(revenue_amount/ 1000,2), "K") Total_Revenue
    FROM Opportunity
WHERE stage IN ('Propose Solution','Qualify Opportunity')
ORDER BY revenue_amount DESC
limit 5;
