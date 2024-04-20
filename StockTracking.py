items = {
    "Apple": {"price": 1.99, "stock": 100},
    "Banana": {"price": 0.99, "stock": 50},
    "Carrot": {"price": 0.49, "stock": 200},
    "Donut": {"price": 2.99, "stock": 30},
    "Egg": {"price": 1.49, "stock": 150}
}

def display_items(items, sort_by="alphabetical", sort_order="ascending"):
    print("-" * 20)
    print("Stock Tracking")
    print("-" * 20)
    if sort_by == "alphabetical":
        sorted_items = sorted(items.items())
    elif sort_by == "stock":
        if sort_order == "ascending":
            sorted_items = sorted(items.items(), key=lambda x: x[1]["stock"])
        elif sort_order == "descending":
            sorted_items = sorted(items.items(), key=lambda x: x[1]["stock"], reverse=True)
        else:
            print("Invalid sort order. Defaulting to ascending order.")
            sorted_items = sorted(items.items(), key=lambda x: x[1]["stock"])
    else:
        print("Invalid sort option. Defaulting to alphabetical order.")
        sorted_items = sorted(items.items())
    for item, details in sorted_items:
        print(f"{item}: ${details['price']} - Stock: {details['stock']}")

def main():
    while True:
        print("-" * 35)
        print("- MapuMart Stock Tracking System -")
        print("-" * 35)
        print("1. View items in alphabetical order")
        print("View items by stock availability")
        print("2. Ascending order")
        print("3. Descending order")
        print("4. Exit")
        choice = input("Enter your choice: ")
        if choice == "1":
            display_items(items, sort_by="alphabetical")
        elif choice == "2":
            display_items(items, sort_by="stock", sort_order="ascending")
        elif choice == "3":
            display_items(items, sort_by="stock", sort_order="descending")
        elif choice == "4":
            print("Thank you for using MapuMart Stock Tracking System.")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()