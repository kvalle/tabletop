#!/usr/bin/env python

import json
import sys 
import requests
import xmltodict

import bgg

# https://boardgamegeek.com/wiki/page/BGG_XML_API
# https://boardgamegeek.com/wiki/page/BGG_XML_API2

try:
	username = sys.argv[1]
except:
	username = "kvalle"

print(bgg.get_collection(username))
