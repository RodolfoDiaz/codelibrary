# -*- coding: utf-8 -*-
"""Code sample: usage of requests module and json data."""

import requests
import time
import os


def current_weather():
    """Public method (docstring)."""
    city = input('Enter the city name: ')
    country = input('Enter the two letters country code'
                    ' (use ISO 3166 country codes): ')

    url = "http://api.openweathermap.org/data/2.5/weather?"\
          "q={0},{1}&APPID=58d04cd0aea2985db211aa028ccb9f4e"\
          "&units=metric&lang=en"
    r = requests.get(url.format(city, country))

    weather_json = r.json()
    # print(weather_json)

    location = weather_json['name'] + ', ' + weather_json['sys']['country']
    description = weather_json['weather'][0]['description']
    temp = weather_json['main']['temp']

    if time.tzname[0] == 'UTC':
        os.environ['TZ'] = 'US/Central'
        time.tzset()
    else:
        print('Current timezone is: {0}'.format(time.tzname))

    sunrise = time.strftime('%Y-%m-%d %H:%M:%S',
                            time.localtime(weather_json['sys']['sunrise']))
    sunset = time.strftime('%Y-%m-%d %H:%M:%S',
                           time.localtime(weather_json['sys']['sunset']))

    print("In {0} current weather is {1}. The temperature is {2}° celcius,"
          " estimated sunrise {3} and sunset {4}".
          format(location, description, temp, sunrise, sunset))


def main():
    """Public method (docstring)."""
    current_weather()


main()
