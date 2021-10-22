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

-- Visit and Action per day for all visits

select
	date(visit_last_action_time) as date,
	count(distinct idvisitor) as unique_visits,
	count(idvisit) as visits,
	count(user_id) as users,
	sum(visit_total_actions) as actions,
	max(visit_total_actions) as max_action,
	sum(visit_total_time) as time_spent,
from matomo.matomo_log_visit
group by date(visit_last_action_time)
order by idvisit desc
limit 0,30;

-- Visit and Action per day for new visits

select
	date(visit_last_action_time) as date,
	count(visitor_returning) as new_visits,
	sum(visit_total_actions) as new_actions,
	count(user_id) as new_user,
	max(visit_total_actions) as max_new_action,
	round(avg(visit_total_actions),1) as avg_action_per_new_visit,
	round(avg(visit_total_time),1) as avg_time_spent_by_new_visitor
from matomo.matomo_log_visit
where visitor_returning = 0
group by date(visit_last_action_time)
order by idvisit desc
limit 0,30;

-- Visit and Action per day for returning visits

select
	date(visit_last_action_time) as date,
	count(visitor_returning) as returning_visitors,
	sum(visit_total_actions) as actions_by_returning_visitors,
	count(distinct idvisitor) as unique_returning_visitor,
	count(user_id) as returning_users,
	max(visit_total_actions) as max_action_returning_visitor,
	round(avg(visit_total_actions),1) as avg_action_per_returning_visit,
	round(avg(visit_total_time),1) as avg_time_spent_by_returning_visitor
from matomo.matomo_log_visit
where visitor_returning = 1
group by date(visit_last_action_time)
order by idvisit desc
limit 0,30;

-- Visitors from .....

-- Direct entry

select
	date(visit_last_action_time) as date,
	count(case 
			when referer_type = 1 
				then referer_type 
			else null 
			end) as direct_entry,
	concat(round(count(case 
			when referer_type = 1
				then referer_type
			else null
			end) *100 / (select count(referer_type))), '%')
				as percent_direct_entry,
	count(case 
			when referer_type = 2 
				then referer_type 
			else null 
			end) as search_engine_entry,
	count(distinct case 
			when referer_type = 2 
				then idvisitor 
			else null 
			end) as distinct_search_engine_entry,
	count(distinct case
			when referer_type = 2
				then referer_url
			else null
			end) as distinct_search_engine,
	concat(round(count(case 
			when referer_type = 2
				then referer_type
			else null
			end) *100 / (select count(referer_type))), '%')
				as percent_search_engine_entry,
	count(case 
			when referer_type = 3 
				then referer_type 
			else null 
			end) as website_entry, 
	count(distinct case 
			when referer_type = 3 
				then idvisitor 
			else null 
			end) as distinct_website_entry,
	count(distinct case 
			when referer_type = 3 
				then referer_url 
			else null 
			end) as distinct_website,
	concat(round(count(case 
			when referer_type = 3
				then referer_type
			else null
			end) *100 / (select count(referer_type))), '%')
				as percent_website_entry,
	count(case 
			when referer_type = 6 
				then referer_type 
			else null 
			end) as campaign_entry,
	count(distinct case 
			when referer_type = 6 
				then idvisitor 
			else null 
			end) as distinct_campaign_entry,
	count(distinct case 
			when referer_type = 6 
				then referer_url 
			else null 
			end) as distinct_campaign,
	concat(round(count(case 
			when referer_type = 6
				then referer_type
			else null
			end) *100 / (select count(referer_type))), '%')
				as percent_campaign_entry,
	count(case 
			when referer_type = 7 
				then referer_type 
			else null 
			end) as social_network,
	count(distinct case 
			when referer_type = 7 
				then idvisitor 
			else null 
			end) as distinct_social_network_entry,
	count(distinct case 
			when referer_type = 7 
				then referer_url 
			else null 
			end) as distinct_social_network,
	concat(round(count(case 
			when referer_type = 7
				then referer_type
			else null
			end) *100 / (select count(referer_type))), '%')
				as percent_social_network_entry,
	count(distinct referer_keyword) as distinct_keywords
from matomo.matomo_log_visit
group by date(visit_last_action_time)
order by idvisit desc
limit 0,30;
	
-- Search Engines

select 
	date(visit_last_action_time) as date,
	referer_name,
	referer_url,
	referer_keyword 
from matomo.matomo_log_visit
where referer_type = 2
		and visit_last_action_time > now() - interval 24 hour
order by idvisit desc;

-- Website

select 
	date(visit_last_action_time) as date,
	referer_name,
	referer_url,
	referer_keyword 
from matomo.matomo_log_visit
where referer_type = 3 
	and visit_last_action_time > now() - interval 24 hour
order by idvisit desc;

-- Campaign

select 
	date(visit_last_action_time) as date,
	referer_name,
	referer_url,
	referer_keyword 
from matomo.matomo_log_visit
where referer_type = 6 
	and visit_last_action_time > now() - interval 24 hour
order by idvisit desc;

-- Social Network

select 
	date(visit_last_action_time) as date,
	referer_name,
	referer_url,
	referer_keyword 
from matomo.matomo_log_visit
where referer_type = 7 
	and visit_last_action_time > now() - interval 24 hour
order by idvisit desc;

-- 
 
select * from matomo.matomo_log_visit order by idvisit desc limit 0,30;
select * from matomo.matomo_log_link_visit_action order by idvisit desc limit 0,10;
select * from matomo.matomo_log_action order by idaction desc limit 2,1;

		
	
