# -*- coding: utf-8 -*-
"""Code sample: declaration of classes."""


class Classroom:
    """Class Classroom."""

    def __init__(self):
        """Public method (docstring)."""
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


class Person:
    """Class Person."""

    def __init__(self, name):
        """Public method (docstring)."""
        self.name = name

    def say_hello(self):
        """Public method (docstring)."""
        print(id(self))
        print("Hello, ", self.name)


room = Classroom()
room.add_person(Person("Scott"))
room.add_person(Person("Poonam"))
room.add_person(Person("Paul"))

room.greet()
