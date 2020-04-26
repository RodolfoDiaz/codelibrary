"""one.py code."""

# built in variable __name__ that compiler assigns


def func():
    """Docstring text for public method."""
    print("FUNC() in ONE.PY")


print("TOP LEVEL IN ONE.PY")

if __name__ == "__main__":
    print("ONE.PY Is beign run directly")
else:
    print("ONE.PY has been imported")
