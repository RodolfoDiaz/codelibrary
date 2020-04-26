"""Circle module."""


class Circle:
    """Circle class."""

    # Class object attributes apply to all instances (go before __init__)
    pi = 3.141592

    def __init__(self, radius=1):
        """Circle gets instantiated with a radius (default is 1)."""
        self.radius = radius
        self.area = radius * radius * Circle.pi

    def setRadius(self, new_radius):
        """Set method for resetting Radius."""
        self.radius = new_radius
        self.area = new_radius * new_radius * Circle.pi

    def getCircumference(self):
        """Get method for getting Circumference."""
        return self.radius * Circle.pi * 2

    def getArea(self):
        """Get method for getting the Area."""
        return self.area


radius_value = float(input("Enter the radius value (number): "))
c = Circle(radius_value)

print("Radius is: ", c.radius)
print("Area is: ", c.getArea())
print("Circumference is: ", c.getCircumference())
