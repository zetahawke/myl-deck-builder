import urllib3
import json

API_MYL_BASE = 'https://api.myl.cl/'
PROFILE_ENDPOINT = 'cards/profile' # complete with <edition_name_slug>/<card_name_slug>
EDITION_ENDPOINT = 'cards/edition' # complete with <edition_name_slug>

def client_connector(method, endpoint):
  http_client = urllib3.PoolManager()

  response = http_client.request(method, f'{API_MYL_BASE}{endpoint}')
  if str(response.status) == '200':
    return json.loads(response.data.decode('utf-8'))
  else:
    return { "error": f"couldn't get any valid response, bad request", "status": "400" }

print(client_connector('GET', f'{EDITION_ENDPOINT}/helenica'))