class SavingsAccount:
    def __init__(self, name, balance):
        self.name = name
        self.balance = balance
    
    def __str__(self):
        return f"Account Name: {self.name}, Balance: ${self.balance:.2f}"
    
    def __lt__(self, other):
        return self.name < other.name

class Bank:
    def __init__(self):
        self.accounts = []
    
    def add_account(self, account):
        self.accounts.append(account)
    
    def __str__(self):
        sorted_accounts = sorted(self.accounts)
        accounts_info = "\n".join(str(account) for account in sorted_accounts)
        return f"Bank Accounts:\n{accounts_info}"
bank = Bank()
bank.add_account(SavingsAccount("Aban", 1500))
bank.add_account(SavingsAccount("Mangahas", 2000))
bank.add_account(SavingsAccount("Mateo", 1000))

print(bank)
