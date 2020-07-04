#!/usr/bin/env python

import requests
import time
from datetime import datetime
import dateutil.parser
import dateutil.tz


def resprint(result):
    for i in range(len(result.keys())):
        print(f"Name:\t\t{result[i]['name']}")
        print(f"Type:\t\t{result[i]['type']}")
        print(f"Duration:\t{result[i]['duration']} min")
        print(f"Start Time:\t{result[i]['startTime']}")
        print()


def codeforces():
    # Codeforces.com API
    print(":: Connecting to codeforces server...")
    res = requests.get('https://codeforces.com/api/contest.list?gym=false')
    if res.status_code != 200:
        print('unable to contact codeforces server. status_code: ' + str(res.status_code))
        return
    json_res = res.json()
    contests = [ contest for contest in json_res['result'] if contest['phase']=="BEFORE" ]
    contests.sort(key=lambda x: x['startTimeSeconds'])
    result = {}
    for i in range(len(contests)):
        contest = contests[i]
        result[i] = {}
        result[i]['name'] = contest['name']
        result[i]['type'] = contest['type']
        result[i]['duration'] = int(contest['durationSeconds'])/60
        result[i]['startTime'] = datetime.fromtimestamp(float(contest['startTimeSeconds']))
    return result


def codechef():
    # Codechef.com from kontests.net API
    print(":: Connecting to codeforces/kontests server...")
    res = requests.get("https://www.kontests.net/api/v1/code_chef")
    if res.status_code != 200:
        print('unable to contact codeforces server. status_code: ' + str(res.status_code))
        return
    json_res = res.json()
    result = {}
    x = 0
    my_zone = dateutil.tz.tzlocal()
    for i in range(len(json_res)):
        if float(json_res[i]['duration']) > 2678400: continue
        result[x] = {}
        result[x]['name'] = json_res[i]['name']
        result[x]['type'] = json_res[i]['status']
        result[x]['duration'] = float(json_res[i]['duration'])/60
        result[x]['startTime'] = dateutil.parser.parse(json_res[i]['start_time']).astimezone(my_zone)
        x += 1
    return result


def main():
    resprint(codeforces())
    resprint(codechef())


if __name__ == "__main__":
    main()
    a = "Commands: exit, refetch, codeforces"
    print(a)
    try: 
        while(a!="exit"):
            a = input(" > ")
            if a == "refetch":
                main()
            elif a == "codeforces":
                resprint(codeforces())
            elif a == "codechef":
                resprint(codechef())
    except KeyboardInterrupt:
        print("\r Exiting.")
