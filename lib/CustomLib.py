import random
import string
import json
import requests

__version__ = '1.0.0'


class CustomLib(object):
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def query_json(self, json_data, key, value):
        results = []
        for item in json_data:
            if item.get(key) == value:
                results.append(item)
        return results


    def get_results_from_api(self, url):
        try:
            # Send GET request
            response = requests.get(url)

            # Check if request was successful (status code 200)
            if response.status_code == 200:
                # Parse response JSON
                data = response.json()

                # Extract 'results' array
                results = data.get('results', [])

                # Return JSON object containing 'results' array
                return results

            else:
                print("Request was not successful. Status code:", response.status_code)
                return None

        except requests.exceptions.RequestException as e:
            print("Error:", e)
            return None
        
    def get_json_length(self, json_data):
        return len(json_data)

    def is_string(self, variable):
        if type(variable) == str:
            print("Variable is a string")
            return True
        else:
            print("Variable is not a string")
            return False
    

