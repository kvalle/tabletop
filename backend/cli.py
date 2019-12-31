#!/usr/bin/env python

import traceback
import json
import sys 
import requests
import xmltodict

import bgg


if len(sys.argv) >= 2:
	username = sys.argv[1]
else:
	username = "kvalle"


try:
	games = bgg.get_games_by_username(username)
	games_json = json.dumps(games, indent=2)
	print(games_json)

except bgg.BggError as err:
	print("ERROR: ", err)

except Exception:
	print("Something unexpected went wrong:")
	traceback.print_exc()
