#! /usr/bin/python
from bs4 import BeautifulSoup
import requests

url = 'https://www.dagensnamn.nu/'
resp = requests.get(url)
html = resp.text
soup = BeautifulSoup(html, "html.parser")
#print("Namnsdag idag: " + soup.find("div", {"class": "text-vertical-center"}).get_text().split("har")[1].split("...")[0])
name_info = soup.find("div", {"class": "text-vertical-center"}).get_text().split("har")[1].split("...")[0]
if "ingen namnsdag" in name_info or len(name_info) > 100:
    pass
else:
    print("Namnsdag idag:", name_info, len(name_info))
