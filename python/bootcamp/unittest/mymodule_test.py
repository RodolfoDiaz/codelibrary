"""Unit testing sample modules."""

import unittest
import cap
import convert_str


class TestCap(unittest.TestCase):
    """Unit test class that derives from unittest.TestCase."""

    def test_one_word(self):
        """Unit test one word."""
        text = 'python'
        result = cap.cap_text(text)
        self.assertEqual(result, 'Python')

    def test_multiple_word(self):
        """Unit test one word."""
        text = 'monty python'
        result = cap.title_text(text)
        self.assertEqual(result, 'Monty Python')

    def test_convert_str(self):
        """Unit test convert string to mixed caps."""
        text = 'Hello World'
        result = convert_str.myfunc(text)
        self.assertEqual(result, 'HeLlO WoRlD')


if __name__ == "__main__":
    unittest.main()
