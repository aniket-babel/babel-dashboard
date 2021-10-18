-- Visit and Actions in 24 hours

select 
	count(idvisitor) as visits
from matomo.matomo_log_visit 
where 
	visit_first_action_time > now() - interval 24 hour;
	
select 
	count(server_time) as actions
from matomo.matomo_log_link_visit_action 
where 
	server_time > now() - interval 24 hour;

-- Visit and Actions in 30 min

select
	count(idvisitor) as visits
from matomo.matomo_log_visit
where 
	visit_first_action_time > now() - interval 30 minute;

select
	count(server_time) as actions
from matomo.matomo_log_link_visit_action
where 
	server_time > now() - interval 30 minute;

-- Location details of the visitor

select
	location_country,
	location_region,
	location_city,
	location_browser_lang,
	location_ip,
	idvisitor
from matomo.matomo_log_visit
order by idvisit desc
limit 0,8;

-- Visitor's browser details

select 
	config_browser_name,
	config_browser_engine,
	config_cookie,
	config_flash,
	config_cookie,
	config_java,
	config_pdf,
	config_quicktime,
	config_silverlight, 
	config_windowsmedia
from matomo.matomo_log_visit
order by idvisit desc
limit 0,8;

-- Operating system of the device

select
	config_os
from matomo.matomo_log_visit
order by idvisit desc
limit 0,8;

-- Device details

select
	config_device_type,
	config_device_brand,
	config_device_model,
	config_resolution
from matomo.matomo_log_visit 
order by idvisit desc 
limit 0,8;

-- Summary of visitor

select 
	visit_total_time,
	visit_total_actions,
	visit_total_interactions,
	visit_total_events,
	visitor_count_visits,
	visitor_returning,
	visit_goal_converted
from matomo.matomo_log_visit
order by idvisit desc 
limit 0,8;

-- Visits overtime

select
	date(visit_last_action_time) as date,
	count(distinct idvisitor) as unique_visits,
	count(idvisit) as visits,
	count(user_id) as users,
	count(visit_total_actions) as actions
from matomo.matomo_log_visit
group by date(visit_last_action_time)
order by idvisit desc
limit 0,30;

select * from matomo.matomo_log_visit order by idvisit desc limit 0,30;
select * from matomo.matomo_log_link_visit_action order by idvisit desc limit 0,10;
select * from matomo.matomo_log_action order by idaction desc limit 2,1;


		
	
