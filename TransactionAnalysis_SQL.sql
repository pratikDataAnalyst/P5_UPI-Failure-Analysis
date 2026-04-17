Create Database UpiAnalysis;
USE upianalysis;
create Table transactions(
transaction_id int,
user_id int,
amount int,
status varchar(20),
bank varchar(20),
timestamp datetime,
device varchar(10),
retry_count int,
error_code varchar(50)
);
select * from transactions;
select count(*)from transactions;

## Success vs Failed
select status, count(*) as total
from transactions
group by status;

## Bank-wise Failures.
select bank,count(*) as Failed_count
from transactions
where  status="failed"
group by bank
order by Failed_count desc;

## Hour-wise Failures.
select hour(timestamp) as hour,count(*) as Failed_count
from transactions
where status ="failed"
group by hour
order by hour;

##Peak vs Non-Peak.
SELECT 
    CASE 
        WHEN HOUR(timestamp) BETWEEN 18 AND 22 THEN 'Peak'
        ELSE 'Non-Peak'
    END AS peak_type,
    COUNT(*) AS failed_count
FROM transactions
WHERE status = 'failed'
GROUP BY peak_type;

##WHY Failures
select error_code, count(*) as total
from transactions 
where status ="failed"
group by error_code
order by total desc;
##Device-wise Failures
select device ,count(*) as Failed_count
from transactions
where status = "Failed"
group by device;
## user retry or not
select retry_count,count(*) as total_trx
from transactions
group by retry_count
order by retry_count;

## Amount vs Failures
##Do high-value payments fail more?
SELECT 
    CASE 
        WHEN amount < 500 THEN 'Low'
        WHEN amount BETWEEN 500 AND 2000 THEN 'Medium'
        ELSE 'High'
    END AS amount_range,
    COUNT(*) AS failed_count
FROM transactions
WHERE status = 'failed'
GROUP BY amount_range;

