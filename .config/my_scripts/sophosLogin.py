#!/bin/python3
import requests
import time

url = "http://172.16.0.30:8090/login.xml"
headers = {
        "Content-Type": "application/x-www-form-urlencoded"
}
data = {
        "mode": "191",
        "username": "f20170202",
        "password": "Matrix@675",
        "a": int(time.time()*1000),
        "producttype": "0"
}
r = requests.post(url, headers=headers, data=data, timeout=5)
res = r.content.decode('utf-8')
print(f'status code = {r.status_code}')
print(res)
if r.status_code != 200 or 'failed' in res or 'Invalid' in res:
    exit(1)
