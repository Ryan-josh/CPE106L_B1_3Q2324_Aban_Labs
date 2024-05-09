import flet as ft
import csv
from csv import writer
import pandas as pd
from flet import *
from flet_route import Params, Basket

class ViewTransactions:
    def __init__(self):
        super().__init__()
        pass
    def Return(self,e:ControlEvent):
        e.page.go("/")
        
    def close_dlg(self, e: UserControl):
        e.page.close_dialog()
        
    def validate(self,e: ControlEvent) -> None:
        if all([self.AddName.value,self.AddPrice.value,self.AddStock.value]):
            self.AddItemButton.disabled = False
            
        else:
            self.AddItemButton.disabled = True
        
        e.page.dialog.update()

    def Add(self, e: ControlEvent) -> None:
            NewItem = [self.AddName.value,self.AddPrice.value,self.AddStock.value]
            with open ('objects/catalog.csv','a') as AppendCatalog:
                 writerCatalog = writer(AppendCatalog)
                 writerCatalog.writerow(NewItem)
                 AppendCatalog.close()
            
            self.close_dlg(e)

            
    def AddItem(self, e: ControlEvent) -> None:
        self.AddName: TextField = TextField(label="Name",on_change=self.validate)
        self.AddPrice: TextField = TextField(label="Price(PHP)",on_change=self.validate)
        self.AddStock: TextField = TextField(label="Stock",on_change=self.validate)
        self.AddItemButton: TextButton = TextButton("Add Item",on_click=self.Add,disabled=True)
        self.CancelAdd: TextButton = TextButton("Cancel",on_click=self.close_dlg)
        self.AddDialog: AlertDialog = AlertDialog(
            title=Text("Add Item"),
            content=Column(controls =[self.AddName,
                                      self.AddPrice,self.AddStock]),
            actions=[self.AddItemButton,
                     self.CancelAdd],
            modal=True,
            )
        e.page.show_dialog(self.AddDialog)
    

        

    def view(self, page: Page, params: Params, basket:Basket):
        User = int(params.get("you_id"))
        self.AdminAccounts = pd.read_csv("objects/admin.csv")
        self.logo: Image = Image(src='objects/MapuMartLogo.png',height=150,width=200,fit=ft.ImageFit.SCALE_DOWN)
        self.Greeting = Text(value=f'Welcome: {self.AdminAccounts["AdminName"][User]}')
        self.ViewCart: ElevatedButton = ElevatedButton(text='View Catalog',width=200,on_click=lambda _: page.go(f"/admincatalog/{User}"))
        self.Browse: ElevatedButton = ElevatedButton(text='View Transaction',width=200)
        self.Checkout: ElevatedButton = ElevatedButton(text='Add Item',width=200,on_click=self.AddItem)
        self.Leave: ElevatedButton = ElevatedButton(text='Log Out',width=200,bgcolor='RED_50',color='RED')
        self.Options = Column(controls=[self.logo,self.Greeting,self.Browse,self.ViewCart,self.Checkout,self.Leave])
        
        self.SearchField: SearchBar = SearchBar(width=600)
        self.SearchResult: Catalog = Catalog(User)
        self.SearchWindow = Column(controls=[self.SearchField,self.SearchResult])
        
        self.UserWindow = Row(controls=[self.Options,self.SearchWindow])
    
        self.Leave.on_click = self.Return
        page.update()
 

        return View(
            "/admintransaction/:you_id",
            controls=[self.UserWindow]
                )

class Catalog(UserControl):
    
    def __init__(self,User:str) -> None:
        super().__init__()
        self.ItemList: DataTable = DataTable(
            columns =[
                ft.DataColumn(ft.Text("Date")),
                ft.DataColumn(ft.Text("Time")),
                ft.DataColumn(ft.Text("Customer")),
                ft.DataColumn(ft.Text("Income")),
                ft.DataColumn(ft.Text(""))],
        
            rows = [],
        
            )
        self.User = User



    def close_dlg(self, e: UserControl):
        e.page.close_dialog()
    
       
    def PurchaseInfo(self,e: ControlEvent) -> None:
        Purchases = e.control.data
        result = [substring.strip() for substring in Purchases.split('/')]
        del result[-1]
        Cart: Column = Column(controls = [])
        for item in result:
            Cart.controls.append(Text(item))
        self.ViewPurchaseDialog: AlertDialog = AlertDialog(content=Cart)
        e.page.show_dialog(self.ViewPurchaseDialog)
        
            
            

        
    def LoadItems(self) -> None:
        df = pd.read_csv('objects/transactions.csv')
        self.ItemList.rows = []
        for item in df.index:
               self.ItemList.rows.append(ft.DataRow(cells=[ft.DataCell(ft.Text(df['Date'][item])),
                                                        ft.DataCell(ft.Text(df['Time'][item])),
                                                        ft.DataCell(ft.Text(df['Customer'][item])),
                                                        ft.DataCell(ft.Text(df['Price'][item])),
                                                        ft.DataCell(ft.ElevatedButton("View Purchases",data = df["Cart"][item],on_click=self.PurchaseInfo))]))
               
    
    
    def build(self) -> Column:
        self.LoadItems()
        self.Scroll: Column = Column(controls = [self.ItemList],height=300,scroll=ScrollMode.ALWAYS)
        return self.Scroll