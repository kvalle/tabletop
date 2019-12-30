import json
import sys 
import requests
import time
import xmltodict

# API reference:
#
# https://boardgamegeek.com/wiki/page/BGG_XML_API
# https://boardgamegeek.com/wiki/page/BGG_XML_API2

class BggError(Exception):
	pass

def get_games_by_username(username):
	collection = get_collection(username)

	game_ids = [game["id"] for game in collection]
	games = get_games_by_id(game_ids)

	update_collection_with_game_details(collection, games)

	return collection


def update_collection_with_game_details(collection, games):
	for collection_game in collection:
		details = [game for game in games if game["id"] == collection_game["id"]]
		if len(details) == 1:
			collection_game.update(details[0])


def get_collection(username):
	collection_xml = get_collection_xml(username)
	collection_data = xmltodict.parse(collection_xml)

	if "errors" in collection_data:
		raise BggError(collection_data["errors"]["error"]["message"])
		
	else:
		return [{
			"id": game["@objectid"],
			"title": get_name(game),
			"year": get_year(game),
			"thumbnail_url": game["thumbnail"],
			"image_url": game["image"],
			"plays": int(game["numplays"])
		} for game in collection_data["items"]["item"]]


def get_collection_xml(username, max_retries = 30):
	url = 'https://www.boardgamegeek.com/xmlapi2/collection?username='+username+'&own=1&excludesubtype=boardgameexpansion'
	collection_request = requests.get(url)

	retries = 0

	while collection_request.status_code == 202:
		if retries > max_retries:
			break

		time.sleep(2.0)
		retries += 1

		collection_request = requests.get(url)

	if collection_request.status_code == 200:
		return collection_request.text

	elif collection_request.status_code == 202:
		raise BggError("Still waiting for BGG to process after " + str(max_retries) + " retries")

	else:
		raise BggError("API error [" + collection_request.status_code + "] while getting collection: " + r.text)


def get_games_by_id(game_ids):
	games_request = requests.get('https://www.boardgamegeek.com/xmlapi/boardgame/' + ",".join(game_ids) + "?stats=1")

	if games_request.status_code == 200:
		games_data = xmltodict.parse(games_request.text)

		return [{
			"id": game["@objectid"],
			"title": get_name(game),
			"description": game["description"],
			"year": get_year(game),
			"thumbnail_url": game["thumbnail"],
			"image_url": game["image"],
			"designers": get_designers(game),
            "minplayers": game["minplayers"],
            "maxplayers": game["maxplayers"],
            "minplaytime": game["minplaytime"],
            "maxplaytime": game["maxplaytime"],
            "age": game["age"]
		} for game in games_data["boardgames"]["boardgame"]]

	else:
		raise BggError("API error [" + str(games_request.status_code) + "] while getting game details: " + r.text)


def get_designers(game):
	if not "boardgamedesigner" in game:
		return []
	elif isinstance(game["boardgamedesigner"], list):
		return [name["#text"] for name in game["boardgamedesigner"]]
	else:
		return [game["boardgamedesigner"]["#text"]]


def get_name(game):
	if isinstance(game["name"], list):
		return "".join([name["#text"] for name in game["name"] if "@primary" in name])
	else:
		return game["name"]["#text"]

def get_year(game):
	if "yearpublished" in game:
		game["yearpublished"]
	else:
		return None
