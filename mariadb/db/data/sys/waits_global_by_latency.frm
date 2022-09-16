TYPE=VIEW
query=select `performance_schema`.`events_waits_summary_global_by_event_name`.`EVENT_NAME` AS `events`,`performance_schema`.`events_waits_summary_global_by_event_name`.`COUNT_STAR` AS `total`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT`) AS `total_latency`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`AVG_TIMER_WAIT`) AS `avg_latency`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`MAX_TIMER_WAIT`) AS `max_latency` from `performance_schema`.`events_waits_summary_global_by_event_name` where `performance_schema`.`events_waits_summary_global_by_event_name`.`EVENT_NAME` <> \'idle\' and `performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT` > 0 order by `performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT` desc
md5=818952ed16255f183d963b428aa0c5b5
updatable=1
algorithm=1
definer_user=mariadb.sys
definer_host=localhost
suid=0
with_check_option=0
timestamp=2022-03-18 01:54:08
create-version=2
source=SELECT event_name AS event,\n       count_star AS total,\n       sys.format_time(sum_timer_wait) AS total_latency,\n       sys.format_time(avg_timer_wait) AS avg_latency,\n       sys.format_time(max_timer_wait) AS max_latency\n  FROM performance_schema.events_waits_summary_global_by_event_name\n WHERE event_name != \'idle\'\n   AND sum_timer_wait > 0\n ORDER BY sum_timer_wait DESC;
client_cs_name=utf8mb3
connection_cl_name=utf8mb3_general_ci
view_body_utf8=select `performance_schema`.`events_waits_summary_global_by_event_name`.`EVENT_NAME` AS `events`,`performance_schema`.`events_waits_summary_global_by_event_name`.`COUNT_STAR` AS `total`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT`) AS `total_latency`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`AVG_TIMER_WAIT`) AS `avg_latency`,`sys`.`format_time`(`performance_schema`.`events_waits_summary_global_by_event_name`.`MAX_TIMER_WAIT`) AS `max_latency` from `performance_schema`.`events_waits_summary_global_by_event_name` where `performance_schema`.`events_waits_summary_global_by_event_name`.`EVENT_NAME` <> \'idle\' and `performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT` > 0 order by `performance_schema`.`events_waits_summary_global_by_event_name`.`SUM_TIMER_WAIT` desc
mariadb-version=100703
