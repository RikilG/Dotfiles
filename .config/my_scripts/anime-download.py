#!/usr/bin/env python

import os
import re
import json
import requests
import argparse
import subprocess
from pathlib import Path
from bs4 import BeautifulSoup as BS

# Folder name: anime uri title name(animeout.xyz/dr-stone/)
titles = {
    "Black Clover": "black-clover-bluray720p1080pepisode-106",
    "Boruto": "boruto",
    # "Dr Stone": "dr-stone",
    "One Piece": "download-one-piece-episodes-latest",
}

anime_dir = Path("/mnt/DC/DC++/Anime")

# helper function to die!
def die(message):
    print(message)
    exit(1)


def notify(title, message):
    subprocess.run(["notify-send", title, message])


def download(url, target):
    _url = re.sub(r" ", "%20", url)
    _url = re.sub(r"^(http[s]?://)", r"\1public.animeout.xyz/", _url)
    print(f"Downloading to {target} ...")
    notify("Starting Download", target)
    ret = subprocess.run(["/usr/bin/aria2c", "-j3", "-x3", "-s3", "-c", _url, "-o", target], cwd="/")
    if ret.returncode != 0:
        print(f"No new files are available or network connection is lost...(return code: {ret.returncode})")
        notify("Anime Download Error", f"No new files are available or network connection is lost...(return code: {ret.returncode})")
        return ret.returncode
    else: print(f"*********\nDONE: {target}\n*********")
    return 0


def get_page(web_title, folder, episode=None):
    page = requests.get(f"https://www.animeout.xyz/{web_title}/")
    assert page.status_code == 200
    soup = BS(page.content, 'html.parser')
    links = soup.find_all("a", attrs={"href": re.compile(r"720p")}, string=re.compile(r"[Dd]irect[\s]*[Dd]ownload"))

    with open(folder/"props.json", 'r') as f:
        props = f.read()
    props = json.loads(props)
    if episode is None:
        ep = int(props["current"])
        folder_list = os.listdir(folder)
        def ep_exists(epno): # function to check if episode already is downloaded
            for x in folder_list:
                if str(epno) in x:
                    return True
            return False
        while ep_exists(ep):# if episode exists, check for the next one
            ep += 1
        ep -= 1 # ep always represent last episode in folder
    else: ep = episode-1 # this is incremented again in while loop
    fmt = props["format"]

    while True: # find extension
        ep += 1
        print("Searching for:", ep)
        filename = re.sub(r"#{2,3}", str(ep), fmt)
        url = None
        for link in links:
            url = link.attrs['href']
            m = re.search(str(ep), url)
            if m:
                break;
            url = None
        if url is None:
            print("No URL found to download")
            return 1
        ext = re.search(r"(\..{1,4})$", url).group(0)
        filename += ext
        ret = download(url, str(folder/filename))
        if episode is not None: return 0 # stop if only one episode is specified
        props["current"] = ep
        with open(folder/"props.json", 'w') as f:
            f.write(json.dumps(props))
        if ret != 0: break;
        notify("Downloaded", str(folder/filename))


def print_available(title_list=None):
    if title_list is None: title_list = sorted(list(titles.keys()))
    print("\t0) Try All listed anime")
    for i in range(len(title_list)):
        print(f"\t{i+1}) {title_list[i]}")
    print(f"\t{len(title_list)+1}) Options")


def main(choice=None, ep=None):
    print("Welcome to Anime Downloader\n")
    title_list = sorted(list(titles.keys()))
    if choice is None:
        print_available(title_list)
        choice = int(input("\nplease select and option: "))-1
    else: choice -= 1
    
    if choice == -1:
        for title in titles.keys():
            print(f"Anime: {title}")
            get_page(titles[title], anime_dir/title)
    elif choice == len(title_list):
        print("Options")
        exit(0)
    elif choice > len(title_list) or choice < -1:
        die("Invalid choice!")
    else:
        get_page(titles[ title_list[choice] ], anime_dir/title_list[choice], ep)
    

def prechecks():
    
    if not anime_dir.exists(): die("Incorrect anime_dir path") # check if anime folder exists
    # check if each anime folder exists
    for title in titles.keys():
        if not (anime_dir/title).exists():
            print(f"Creating dir for {title}: {anime_dir/title}")
            os.mkdirs(anime_dir/title)
        if not (anime_dir/title/"props.json").exists():
            print(f"Setting up props file for {title}")
            ep = input(f"Enter last episode no.(present on disk) for {title} (default = 0): ") or 0
            ep = int(ep)
            temp = input(f"Enter format for {title} (default = {title} - ###): ") or f"{title} - ###"
            props = {
                "current": ep,
                "format": str(temp)
            }
            with open(anime_dir/title/"props.json", 'w') as f:
                f.write(json.dumps(props))

if __name__ == "__main__":
    # setup argparse
    parser = argparse.ArgumentParser(description='Download anime with no fuss!')
    parser.add_argument("-a", "--all", action="store_true", help="download all anime")
    # parser.add_argument("-i", "--interactive", action="store_true", help="run in interactive mode")
    parser.add_argument("-l", "--list", action="store_true", help="list available anime")
    parser.add_argument("-c", "--choice", default=None, type=int, help="anime selection number(use -l to get numbers, overidden by -a)")
    parser.add_argument("-ep", "--episode", default=None, type=int, help="episode number to search for")
    args = parser.parse_args()
    if args.list: 
        print_available()
        exit(0)
    if args.all: args.choice = 0
    # run prechecks to check if all required folders and prop files exist
    prechecks()
    # run the program
    main(args.choice, args.episode)
