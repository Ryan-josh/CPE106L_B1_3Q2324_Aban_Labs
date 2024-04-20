def display_menu(menu):
    print("-" * 50)
    for item_num, (item_name, price, stock) in menu.items():
        print(f"{item_num}. {item_name} - {price} pesos (Stock: {stock})")
    print("-" * 50)

def order_again():
    while True:
        order_again = input("Do you want to order again? (yes/no): ").lower()
        if order_again == "yes":
            return True
        elif order_again == "no":
            return False
        else:
            print("Invalid input. Please enter 'yes' or 'no'.")

def main():
    print("Welcome to the Simple Ordering System!")
    print("Here are the available foods and groceries:")

    menu = {
        1: ("Apples", 50, 20),
        2: ("Bananas", 30, 30),
        3: ("Bread", 40, 15),
        4: ("Milk", 70, 10),
        5: ("Eggs", 60, 12),
    }

    total_amount = 0
    ordered_items = {}

    while True:
        display_menu(menu)
        item_choice = int(input("Enter the number of the item you want to order: "))
        quantity = int(input(f"Enter the quantity of {menu[item_choice][0]}: "))

        if quantity > menu[item_choice][2]:
            print(f"Sorry, there are only {menu[item_choice][2]} {menu[item_choice][0]}s left in stock.")
            continue

        item_name, price = menu[item_choice][:2]
        total_amount += price * quantity

        if item_name in ordered_items:
            ordered_items[item_name][0] += quantity
            ordered_items[item_name][1] = price
        else:
            ordered_items[item_name] = [quantity, price]

        if menu[item_choice][2] - quantity == 0:
            print(f"Sorry, {menu[item_choice][0]} is out of stock. Please choose another item to order.")
            continue

        if not order_again():
            break

    print("\nYour total amount is:", total_amount, "pesos.")
    print("You ordered:")
    for item, (quantity, price) in ordered_items.items():
        print(f"- {quantity} x {item} - {price * quantity} pesos")

if __name__ == "__main__":
    main()