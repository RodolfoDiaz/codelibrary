# -*- coding: utf-8 -*-
"""Code sample: usage of loops."""
import random


def get_random_word():
    """Public method (docstring)."""
    words = ["pizza", "cheese", "apples"]
    word = words[random.randint(0, len(words)-1)]
    return word


def show_word(word):
    """Public method (docstring)."""
    for character in word:
        # print(character, " ", end="")
        print(character, " ")
    print("")


def get_guess():
    """Public method (docstring)."""
    print("Enter a letter: ")
    return raw_input()


def process_letter(letter, secret_word, blanked_word):
    """Public method (docstring)."""
    result = False

    for i in range(0, len(secret_word)):
        if secret_word[i] == letter:
            result = True
            blanked_word[i] = letter

    return result


def print_strikes(number_of_strikes):
    """Public method (docstring)."""
    for i in range(0, number_of_strikes):
        # print("X ", end="")
        print("X ")
    print("")


def play_word_game():
    """Public method (docstring)."""
    strikes = 0
    max_strikes = 3
    playing = True

    word = get_random_word()
    blanked_word = list("_" * len(word))

    while playing:
        show_word(blanked_word)
        letter = get_guess()
        found = process_letter(letter, word, blanked_word)

        if not found:
            strikes += 1
            print_strikes(strikes)

        if strikes >= max_strikes:
            playing = False

        if "_" not in blanked_word:
            playing = False

    if strikes >= max_strikes:
        print("Loser!")
    else:
        print("Winner!")


print("Game started")
play_word_game()
print("Game over")
