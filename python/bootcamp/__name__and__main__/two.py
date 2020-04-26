"""two.py code."""

import one

print("TOP LEVEL IN TWO.PY")

one.func()

if __name__ == "__main__":
    print("TWO.PY Is beign run directly")
else:
    print("TWO.PY has been imported")
