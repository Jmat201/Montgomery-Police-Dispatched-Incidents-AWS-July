import json
import boto3
import urllib3
import datetime

# REPLACE WITH YOUR DATA FIREHOSE NAME
FIREHOSE_NAME = 'PUT-S3-7djDR'

def lambda_handler(event, context):
    
    http = urllib3.PoolManager()
    
    url = ("https://data.montgomerycountymd.gov/resource/98cc-bc7d.json?$query=SELECT%0A%20%20%60incident_id%60%2C%0A%20%20%60cr_number%60%2C%0A%20%20%60crash_reports%60%2C%0A%20%20%60start_time%60%2C%0A%20%20%60end_time%60%2C%0A%20%20%60priority%60%2C%0A%20%20%60initial_type%60%2C%0A%20%20%60close_type%60%2C%0A%20%20%60address%60%2C%0A%20%20%60city%60%2C%0A%20%20%60state%60%2C%0A%20%20%60zip%60%2C%0A%20%20%60longitude%60%2C%0A%20%20%60latitude%60%2C%0A%20%20%60police_district_number%60%2C%0A%20%20%60sector%60%2C%0A%20%20%60pra%60%2C%0A%20%20%60calltime_callroute%60%2C%0A%20%20%60calltime_dispatch%60%2C%0A%20%20%60calltime_arrive%60%2C%0A%20%20%60calltime_cleared%60%2C%0A%20%20%60callroute_dispatch%60%2C%0A%20%20%60dispatch_arrive%60%2C%0A%20%20%60arrive_cleared%60%2C%0A%20%20%60disposition_desc%60%2C%0A%20%20%60geolocation%60%2C%0A%20%20%60%3A%40computed_region_6vgr_duib%60%0AWHERE%0A%20%20%60start_time%60%0A%20%20%20%20BETWEEN%20%222024-06-01T12%3A00%3A00%22%20%3A%3A%20floating_timestamp%0A%20%20%20%20AND%20%222024-06-13T23%3A45%3A00%22%20%3A%3A%20floating_timestamp%0AORDER%20BY%20%60end_time%60%20DESC%20NULL%20FIRST")
    
    r = http.request("GET", url)
    
    # turn it into a dictionary
    r_dict = json.loads(r.data.decode(encoding='utf-8', errors='strict'))
    
    fh = boto3.client('firehose')
    
    for item in r_dict:
        processed_dict = {}
        processed_dict['incident_id'] = item.get('incident_id', '')
        processed_dict['start_time'] = item.get('start_time', '')
        processed_dict['end_time'] = item.get('end_time', '')
        processed_dict['priority'] = item.get('priority', '')
        processed_dict['initial_type'] = item.get('initial_type', '')
        processed_dict['close_type'] = item.get('close_type', '')
        processed_dict['address'] = item.get('address', '')
        processed_dict['city'] = item.get('city', '')
        processed_dict['state'] = item.get('state', '')
        processed_dict['zip'] = item.get('zip', '')
        processed_dict['police_district_number'] = item.get('police_district_number', '')
        processed_dict['sector'] = item.get('sector', '')
        processed_dict['pra'] = item.get('pra', '')
#        processed_dict['calltime_callroute'] = item.get('calltime_callroute', '')
#        processed_dict['calltime_dispatch'] = item.get('calltime_dispatch', '')
#        processed_dict['calltime_arrive'] = item.get('calltime_arrive', '')
#        processed_dict['calltime_cleared'] = item.get('calltime_cleared', '')
#        processed_dict['callroute_dispatch'] = item.get('callroute_dispatch', '')
        processed_dict['dispatch_arrive'] = item.get('dispatch_arrive', '')
        processed_dict['arrive_cleared'] = item.get('arrive_cleared', '')
        processed_dict['disposition_desc'] = item.get('disposition_desc', '')
#        processed_dict['geolocation_type'] = item.get('geolocation', {}).get('type', '')
        processed_dict['geolocation_coordinates'] = item.get('geolocation', {}).get('coordinates', [])
#        processed_dict['computed_region_6vgr_duib'] = item.get(':@computed_region_6vgr_duib', '')
        processed_dict['row_ts'] = str(datetime.datetime.now())
        
        # turn it into a string and add a newline
        msg = json.dumps(processed_dict) + '\n'
        
        reply = fh.put_record(
            DeliveryStreamName=FIREHOSE_NAME,
            Record = {
                    'Data': msg
                    }
        )

    return reply
