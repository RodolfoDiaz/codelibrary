# -*- coding: utf-8 -*-
"""Code sample: declaration of classes."""

from datetime import datetime


class Classroom(object):
    """Class Classroom."""

    def __init__(self):
        """__init__ is used to initialize the attributes of an object."""
        self._people = []

    def add_person(self, person):
        """Public method (docstring)."""
        self._people.append(person)

    def remove_person(self, person):
        """Public method (docstring)."""
        self._people.remove(person)

    def greet(self):
        """Public method (docstring)."""
        for person in self._people:
            person.say_hello()
            print("")
        room.__yell()

    def __yell(self):
        """Private method (docstring)."""
        # To define a private method
        # prefix the member name with double underscore “__”.
        print("SHUT UP EVERYONE")


class Person:
    """Class Person."""

    def __init__(self, name, age, height):
        """Public method (docstring)."""
        self.name = name
        self.age = age
        self.height = height

    def say_hello(self):
        """Public method (docstring)."""
        # String formatting with the .format() method
        print("Hello {}, today is {}"
              .format(self.name, datetime.now().strftime("%d/%m/%Y %H:%M:%S")))
        # Formatting with f-strings (formatted string literals). Python 3.x
        print(f"The internal identity number is: {id(self)}")
        # Formatting float number
        print("Your age is {a} years old, and your height {h:1.2f} m"
              .format(a=self.age, h=self.height))


# Set classroom information
room = Classroom()
room.add_person(Person("Scott", 20, 1.739))
room.add_person(Person("Poonam", 25, 1.663))
room.add_person(Person("Paul", 19, 1.846))

# Take a roll call
room.greet()

try:
    room.__yell()
except AttributeError:
    # You cannot call private methods directly
    pass
except:
    print("An error occurred!")
# But you can call them by using Name mangling
room._Classroom__yell()
