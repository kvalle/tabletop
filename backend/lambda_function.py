import traceback
import json
import bgg

def lambda_handler(event, context):
    
    try:
        username = event["pathParameters"]["username"]
    except:
        return {
            'statusCode': 400,
            'body': json.dumps({"error": "No username"}),
            'headers': {
                "Access-Control-Allow-Origin" : "*"
            }
        }
    
    try:
        games = bgg.get_games_by_username(username)
    
        return {
            'statusCode': 200,
            'body': json.dumps({
                    "status": "SUCCESS",
                    "games": games
                } , indent=2),
            'headers': {
                "Access-Control-Allow-Origin" : "*"
            }
        }
    
    except bgg.BggProcessing:
        return {
            'statusCode': 202,
            'body': json.dumps({"status": "PROCESSING"}),
            'headers': {
                "Access-Control-Allow-Origin" : "*"
            }
        }

    except bgg.BggError as err:
        print("ERROR: ", err)
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                "status": "ERROR",
                "message": "Problem with the integration with BGG"
            }),
            'headers': {
                "Access-Control-Allow-Origin" : "*"
            }
        }
    
    except Exception:
        print("Something unexpected went wrong:")
        traceback.print_exc()
        
        return {
            'statusCode': 500,
            'body': json.dumps({
                "status": "ERROR",
                "message": "An unexpected problem occurred"
            }),
            'headers': {
                "Access-Control-Allow-Origin" : "*"
            }
        }
