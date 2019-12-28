#!/usr/bin/env python

import json
import sys 
import requests
import xmltodict

# API reference:
#
# https://boardgamegeek.com/wiki/page/BGG_XML_API
# https://boardgamegeek.com/wiki/page/BGG_XML_API2

def get_collection(username):

	url = 'https://www.boardgamegeek.com/xmlapi2/collection?username='+username+'&own=1&excludesubtype=boardgameexpansion'
	collection_request = requests.get(url)

	if collection_request.status_code == 202:
		return "Got 202 from BGG, try again soon"

	elif collection_request.status_code == 200:
		data = xmltodict.parse(collection_request.text)

		if "errors" in data:
			return "something went wrong at BGG:" + data["errors"]["error"]["message"]
			
		else:
			game_ids = [game["@objectid"] for game in data["items"]["item"]]
			games_request = requests.get('https://www.boardgamegeek.com/xmlapi/boardgame/' + ",".join(game_ids))

			if games_request.status_code == 200:

				# TODO: noe lurt her…
				
				collection = [{
					"id": game["@objectid"],
					"title": game["name"]["#text"],
					"year": game["yearpublished"] if "yearpublished" in game else None,
					"thumbnail_url": game["thumbnail"],
					"image_url": game["image"],
					"plays": int(game["numplays"])
				} for game in data["items"]["item"]]
				
				return json.dumps(collection)

			else:
				return "Failed to get detiled game data from BGG"

	else:
		return "unexpected status from BGG (" + collection_request.status_code + "): " + r.text
