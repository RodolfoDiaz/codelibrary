# -*- coding: utf-8 -*-
"""Code sample: shopping cart."""


def get_order():
    """Public method (docstring)."""
    print("[command] [item] (command is a to add, d to delete, q to quit)")
    line = raw_input()

    command = line[:1]
    item = line[2:]

    return command, item


def add_to_cart(item, cart):
    """Public method (docstring)."""
    if item not in cart:
        cart[item] = 0
    cart[item] += 1


def delete_from_cart(item, cart):
    """Public method (docstring)."""
    if item in cart:
        cart[item] -= 1


def process_order(order, cart):
    """Public method (docstring)."""
    command, item = order

    if command == "a":
        add_to_cart(item, cart)
    elif command == "d" and item in cart:
        delete_from_cart(item, cart)
    elif command == "q":
        return False

    return True


def go_shopping():
    """Public method (docstring)."""
    cart = dict()

    while True:
        order = get_order()
        if not process_order(order, cart):
            break

    print(cart)
    print("Finished!")


go_shopping()
