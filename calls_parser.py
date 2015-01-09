__author__ = 'anastasia'

import json
import csv

json_data=open('calls-pretty.json').read()

data = json.loads(json_data)

for d in data:
    ds = d.get('_source')
    call_recvip = ds.get('recvip')
    call_duration = ds.get('duration')
    call_start = ds.get('start')
    call_status = ds.get('status')
    call_peerip = ds.get('peerip')
    call_direction = ds.get('direction')
    call_host = ds.get('host')
    call_line = ds.get('line')
    call_callee = ds.get('callee')
    call_caller = ds.get('caller')
    call_uniqueid = ds.get('uniqueid')
    call_billsec = ds.get('billsec')

    with open("calls.csv", 'a') as csvfile:
        calls_writer = csv.writer(csvfile, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        calls_writer.writerow([call_recvip, call_duration, call_start, call_status, call_peerip, call_direction, call_host,
                               call_line, call_callee, call_caller, call_uniqueid, call_billsec])







