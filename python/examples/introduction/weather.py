import requests

def current_weather():
    url = "http://api.openweathermap.org/data/2.5/weather?id=3623486&APPID=58d04cd0aea2985db211aa028ccb9f4e&units=metric&lang=es"
    r = requests.get(url)

    weather_json = r.json()
    print(weather_json)

    min = weather_json['main']['temp_min']
    max = weather_json['main']['temp_max']

    print("The forecast in Heredia is", min , " as the low and", max, " as the high")
