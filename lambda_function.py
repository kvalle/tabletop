import json
import bgg

def lambda_handler(event, context):
    
    username = "kvalle"
    
    try:
        games = bgg.get_games_by_username(username)
        games_json = json.dumps(games, indent=2)
    
        return {
            'statusCode': 200,
            'body': games_json
        }
    
    except bgg.BggError as err:
        print("ERROR: ", err)
        
        return {
            'statusCode': 500,
            'body': json.dumps({"error": "Problem with the integration with BGG"})
        }
    
    except Exception:
        print("Something unexpected went wrong:")
        traceback.print_exc()
        
        return {
            'statusCode': 500,
            'body': json.dumps({"error": "A problem occurred"})
        }
