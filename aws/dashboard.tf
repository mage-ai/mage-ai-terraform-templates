resource "aws_cloudwatch_dashboard" "iterable_mage_dashboard" {
  dashboard_name = "iterable_mage_stats_tf" 

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 12,
            "y": 8,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields @timestamp, successCount, failCount\n| filter context.catalog_name = 'Clinicians'\n| stats sum(successCount) as Success by bin(30m)",
                "region": "us-west-2",
                "stacked": false,
                "title": "Clinicians Catalog",
                "view": "timeSeries"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 2,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields @timestamp, successCount, failCount\n| filter context.catalog_name = 'Jobs'\n| stats sum(successCount) as Success by bin(30m)\n",
                "region": "us-west-2",
                "stacked": false,
                "title": "Jobs Catalog",
                "view": "timeSeries"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 8,
            "x": 12,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields @timestamp, successCount, failCount\n| filter context.catalog_name = 'Facilities'\n| stats sum(successCount) as Success by bin(1d)\n",
                "region": "us-west-2",
                "stacked": false,
                "title": "Facilities Catalog",
                "view": "timeSeries"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Catalogs"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 14,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Events"
            }
        },
        {
            "height": 6,
            "width": 19,
            "y": 31,
            "x": 5,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields @timestamp, successCount, failCount\n| filter context.pipeline_uuid = 'iterable_user_data'\n| stats max(successCount) as Success, max(failCount) as Fail by bin(30m)\n| sort @timestamp desc\n| limit 20\n",
                "region": "us-west-2",
                "stacked": true,
                "title": "Users Uploaded",
                "view": "timeSeries"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 2,
            "x": 12,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields successCount, failCount\n| filter context.pipeline_uuid = 'iterable_catalog'\n| stats sum(successCount) as Success, sum(failCount) as Fail by context.catalog_name\n",
                "region": "us-west-2",
                "stacked": false,
                "title": "Catalog Totals",
                "view": "table"
            }
        },
        {
            "height": 4,
            "width": 5,
            "y": 31,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields successCount, failCount\n| filter context.pipeline_uuid = 'iterable_user_data'\n| stats max(successCount) as unique_users, sum(successCount) as success, sum(failCount) as fail\n",
                "region": "us-west-2",
                "stacked": false,
                "title": "Users - Total Sent (includes duplicates)",
                "view": "table"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 29,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Users"
            }
        },
        {
            "height": 5,
            "width": 7,
            "y": 16,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields successCount, failCount\n| filter context.pipeline_uuid = 'iterable_event'\n| stats sum(successCount) as Success, sum(failCount) as Fail\n",
                "region": "us-west-2",
                "stacked": false,
                "title": "Events - Total Sent ",
                "view": "table"
            }
        },
        {
            "height": 5,
            "width": 17,
            "y": 16,
            "x": 7,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields @timestamp, successCount, failCount\n| filter context.pipeline_uuid = 'iterable_event'\n| stats sum(successCount) as success, sum(failCount) as fail by bin(10m)\n",
                "region": "us-west-2",
                "title": "All Events",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "height": 8,
            "width": 7,
            "y": 21,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields successCount, failCount\n| filter context.pipeline_uuid = 'iterable_event'\n| stats sum(successCount) as Success, sum(failCount) as Fail, Success + Fail as total by context.event_name\n| sort total desc",
                "region": "us-west-2",
                "stacked": false,
                "title": "Events - Total Sent By Event",
                "view": "table"
            }
        },
        {
            "height": 8,
            "width": 17,
            "y": 21,
            "x": 7,
            "type": "log",
            "properties": {
                "query": "SOURCE 'dataeng-mage-prod-logs' | fields \n(context.event_name like 'Job Paid Data V2') as is_job_paid_data_v2,\n(context.event_name like 'Job Requested Data V2') as is_job_requested_data_v2,\n(context.event_name like 'Job Verified Data V2') as is_job_verified_data_v2,\n(context.event_name like 'Job Scheduled Data V2') as is_job_scheduled_data_v2,\n(context.event_name like 'Notification Leads Data V2') as is_notification_leads_data_v2,\n(context.event_name like 'First Request Data V2') as is_first_request_data_v2,\n(context.event_name like 'NCNS Data V2') as is_ncns_data_v2,\n(context.event_name like 'First Job Paid Data') as is_first_job_paid_data,\n(context.event_name like 'License Added Data V2') as is_license_added_data_v2,\n(context.event_name like 'License Verified Data') as is_license_verified_data,\n(context.event_name like 'Abandoned Cart Data') as is_abandoned_cart_data,\n(context.event_name like 'First Job Posted Data') as is_first_job_posted_data,\n(context.event_name like 'Facility Notify Me Data') as is_facility_notify_me_data,\n(context.event_name like 'Notify Me ata') as is_notify_me_data, \n(context.event_name like 'New User Record Data') as is_new_user_record_data,\n(context.event_name like 'Facility Connection Requested Data') as is_facility_connection_requested_data,\n(context.event_name like 'Facility Connection Verified Data') as is_facility_connection_verified_data,\n(context.event_name like 'Shift Created Data') as is_shift_created_data,\n(context.event_name like 'First Shift Scheduled Data') as is_first_shift_scheduled_data,\n(context.event_name like '24hr open shift') as is_24hr_open_shift\n\n| filter context.pipeline_uuid = 'iterable_event'\n| stats \nsum(successCount * is_job_paid_data_v2) as job_paid_data_v2,\nsum(successCount * is_job_requested_data_v2) as job_requested_data_v2,\nsum(successCount * is_job_verified_data_v2) as job_verified_data_v2,\nsum(successCount * is_job_scheduled_data_v2) as job_scheduled_data_v2,\nsum(successCount * is_notification_leads_data_v2) as notification_leads_data_v2,\nsum(successCount * is_first_request_data_v2) as first_request_data_v2,\nsum(successCount * is_ncns_data_v2) as ncns_data_v2,\nsum(successCount * is_first_job_paid_data) as first_job_paid_data,\nsum(successCount * is_license_added_data_v2) as license_added_data_v2,\nsum(successCount * is_license_verified_data) as license_verified_data,\nsum(successCount * is_abandoned_cart_data) as abandoned_cart_data,\nsum(successCount * is_first_job_posted_data) as first_job_posted_data,\nsum(successCount * is_facility_notify_me_data) as facility_notify_me_data,\nsum(successCount * is_notify_me_data) as notify_me_data,\nsum(successCount * is_new_user_record_data) as new_user_record_data,\nsum(successCount * is_facility_connection_requested_data) as facility_connection_requested_data,\nsum(successCount * is_facility_connection_verified_data) as facility_connection_verified_data,\nsum(successCount * is_shift_created_data) as shift_created_data,\nsum(successCount * is_first_shift_scheduled_data) as first_shift_scheduled_data,\nsum(successCount * is_24hr_open_shift) as _24hr_open_shift\nby bin(10m)\n\n",
                "region": "us-west-2",
                "stacked": true,
                "title": "Sent by Event",
                "view": "timeSeries"
            }
        }
    ]
}
EOF
}
