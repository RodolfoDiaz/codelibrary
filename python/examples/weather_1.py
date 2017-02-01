# -*- coding: utf-8 -*-
"""Code sample: usage of requests module and json data."""
import requests


def current_weather():
    """Public method (docstring)."""
    url = "http://api.openweathermap.org/data/2.5/weather?"\
          "id=3623486&APPID=58d04cd0aea2985db211aa028ccb9f4e"\
          "&units=metric&lang=es"
    r = requests.get(url)

    weather_json = r.json()
    print(weather_json)

    location = weather_json['name']
    min = weather_json['main']['temp_min']
    max = weather_json['main']['temp_max']

    print("The forecast in {0} is {1} as the low and {2} as the high".
          format(location, min, max))


def main():
    """Public method (docstring)."""
    current_weather()


main()
