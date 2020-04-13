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
    "Black Clover": {
        "animeout": "black-clover-bluray720p1080pepisode-106",
        "4anime": "https://storage.googleapis.com/linear-theater-254209.appspot.com/v2.4animu.me/Black-Clover/Black-Clover-Episode-###-1080p.mp4",
    },
    "Boruto": {
        "animeout": "boruto",
        "4anime": "https://storage.googleapis.com/linear-theater-254209.appspot.com/v2.4animu.me/Boruto-Naruto-Next-Generations/Boruto-Naruto-Next-Generations-Episode-###-1080p.mp4",
    },
    # "Dr Stone": "dr-stone",
    "One Piece": {
        "animeout": "download-one-piece-episodes-latest",
        # "4anime": "https://v3.4animu.me/One-Piece/One-Piece-Episode-###-1080p.mp4",
        "4anime": "https://storage.googleapis.com/linear-theater-254209.appspot.com/v3.4animu.me/One-Piece/One-Piece-Episode-###-1080p.mp4",
    },
}

anime_dir = Path("/mnt/DC/DC++/Anime")

# some program variables
page = None
links = None

# helper function to die!
def die(message):
    print(message)
    exit(1)

# helper function to send notification
def notify(title, message):
    subprocess.run(["notify-send", title, message])

# download from a given url
def download(url, target):
    print(f"Downloading to {target} ...")
    notify("Starting Download", target)
    ret = subprocess.run(["/usr/bin/aria2c", "-j3", "-x3", "-s3", "-c", url, "-o", target], cwd="/")
    if ret.returncode != 0:
        print(f"No new files are available or network connection is lost...(return code: {ret.returncode})")
        notify("Anime Download Error", f"No new files are available or network connection is lost...(return code: {ret.returncode})")
        return ret.returncode
    else: print(f"*********\nDONE: {target}\n*********")
    return 0

# function to check if episode already is downloaded
def ep_exists(epno, folder):
    for x in os.listdir(folder):
        if str(epno) in x:
            return True
    return False


def _animeout(title, ep):
    global page
    global links
    if page is None:
        page = requests.get(f"https://www.animeout.xyz/{titles[title]['animeout']}/")
        assert page.status_code == 200
        soup = BS(page.content, 'html.parser')
        links = soup.find_all("a", attrs={"href": re.compile(r"720p")}, string=re.compile(r"[Dd]irect[\s]*[Dd]ownload"))
    for link in links:
        url = None
        url = link.attrs['href']
        m = re.search(str(ep), url)
        if m: break; # break this for
    if url is None:
        print("No URL found to download")
        return 1
    url = re.sub(r" ", "%20", url)
    url = re.sub(r"^(http[s]?://)", r"\1public.animeout.xyz/", url)
    return url

def _4anime(title, ep):
    url = titles[title]["4anime"]
    url = re.sub(r"#{2,4}", str(ep), url)
    return url


def fetch_anime(site, title, folder, episode=None):
    with open(folder/"props.json", 'r') as f:
        props = f.read()
    props = json.loads(props)

    if episode is None:     # get current episode
        ep = int(props["current"])
        while ep_exists(ep, folder):# if episode exists, check for the next one
            ep += 1
        ep -= 1     # ep always represent last episode in folder
    else: ep = episode-1 # same reason ^ (this is incremented again in while loop)

    fmt = props["format"]
    while True: # find extension
        ep += 1
        print("Searching for:", ep)
        filename = re.sub(r"#{2,3}", str(ep), fmt)

        if site=="animeout": url = _animeout(title, ep)
        elif site=="4anime": url = _4anime(title, ep)
        else: die("unknown site...")
        if url == 1: return 1

        print("url:", url)
        ext = re.search(r"(\..{1,4})$", url).group(0)
        filename += ext
        ret = download(url, str(folder/filename))
        if episode is not None: return 0 # stop if only one episode is specified
        if ret != 0: break;
        props["current"] = ep
        with open(folder/"props.json", 'w') as f:
            f.write(json.dumps(props))
        notify("Downloaded", str(folder/filename))


def main(site=None, choice=None, ep=None):
    print("\nWelcome to Anime Downloader\n")
    title_list = sorted(list(titles.keys()))
    if choice is None:
        print_available(title_list)
        choice = int(input("\nplease select and option: "))-1
    else: choice -= 1
    
    if choice == -1:
        for title in titles.keys():
            print(f"Anime: {title}")
            fetch_anime(site, title, anime_dir/title)
    elif choice == len(title_list):
        print("Options")
        exit(0)
    elif choice > len(title_list) or choice < -1:
        die("Invalid choice!")
    else:
        fetch_anime(site, title_list[choice], anime_dir/title_list[choice], ep)
    

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


def parseArgs():
    # setup argparse
    parser = argparse.ArgumentParser(description='Download anime with no fuss!')
    parser.add_argument("-a", "--all", action="store_true", help="download all anime")
    parser.add_argument("-s", "--site", default="4anime", help="select site to download from")
    # parser.add_argument("-i", "--interactive", action="store_true", help="run in interactive mode")
    parser.add_argument("-l", "--list", action="store_true", help="list available anime")
    parser.add_argument("-c", "--choice", default=None, type=int, help="anime selection number(use -l to get numbers, overidden by -a)")
    parser.add_argument("-ep", "--episode", default=None, type=int, help="episode number to search for")
    return parser.parse_args()


def print_available(title_list=None):
    if title_list is None: title_list = sorted(list(titles.keys()))
    print("\t0) Try All listed anime")
    for i in range(len(title_list)):
        print(f"\t{i+1}) {title_list[i]}")
    print(f"\t{len(title_list)+1}) Options")


if __name__ == "__main__":
    args = parseArgs()
    if args.list: 
        print_available()
        exit(0)
    if args.all: args.choice = 0
    # run prechecks to check if all required folders and prop files exist
    prechecks()
    # run the program
    main(args.site, args.choice, args.episode)
