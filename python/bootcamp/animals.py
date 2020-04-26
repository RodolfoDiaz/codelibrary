"""Animals module."""


class Animal:
    """Animal class."""

    # Class object attributes apply to all instances (go before __init__)
    is_alive = True

    def __init__(self):
        """__init__ is used to initialize the attributes of an object."""
        print("Animal created")

    def whoAmI(self):
        """Public method (docstring)."""
        print("Animal")

    def eat(self):
        """Public method (docstring)."""
        print("Eating")


class Dog(Animal):
    """Dog class."""

    def __init__(self):
        """__init__ is used to initialize the attributes of an object."""
        Animal.__init__(self)
        print("Dog created")

    def whoAmI(self):
        """Public method (docstring)."""
        print("Dog")

    def bark(self):
        """Public method (docstring)."""
        print("Woof!")


d = Dog()
d.whoAmI()
d.eat()
d.bark()
