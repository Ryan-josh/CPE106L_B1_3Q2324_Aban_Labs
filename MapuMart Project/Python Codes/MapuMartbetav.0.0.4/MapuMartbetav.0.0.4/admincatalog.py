import flet as ft
import csv
from csv import writer
import pandas as pd
from flet import *
from flet_route import Params, Basket

class AdminCatalog:
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
            df = pd.read_csv('objects/catalog.csv')
            df2 = {'ItemName': self.AddName.value, 'ItemStock': self.AddStock.value, 'ItemPrice': self.AddPrice.value}
            df = df._append(df2, ignore_index = True)
            
            df.to_csv('objects/catalog.csv',index=False)
            e.page.clean()
            e.page.update()
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
        self.ViewCart: ElevatedButton = ElevatedButton(text='View Catalog',width=200,)
        self.Browse: ElevatedButton = ElevatedButton(text='View Transaction',width=200,on_click=lambda _: page.go(f"/admintransaction/{User}"))
        self.Checkout: ElevatedButton = ElevatedButton(text='Add Item',width=200,on_click=self.AddItem)
        self.Leave: ElevatedButton = ElevatedButton(text='Log Out',width=200,bgcolor='RED_50',color='RED')
        self.Options = Column(controls=[self.logo,self.Greeting,self.Browse,self.ViewCart,self.Checkout,self.Leave])
        
        self.SearchField: SearchBar = SearchBar(width=600)
        self.SearchResult: Catalog = Catalog(User)
        self.SearchWindow = Column(controls=[self.SearchField,self.SearchResult])
        
        self.UserWindow = Row(controls=[self.Options,self.SearchWindow])
    
        self.Leave.on_click = self.Return
        
        page.window_height = 425
        page.window_width = 900
        page.window_center()
        
        page.update()
        
 

        return View(
            "/admincatalog/:you_id",
            controls=[self.UserWindow]
                )

class Catalog(UserControl):
    
    def __init__(self,User:str) -> None:
        super().__init__()
        self.ItemList: DataTable = DataTable(
            columns =[
                ft.DataColumn(ft.Text("Name")),
                ft.DataColumn(ft.Text("Price(PHP)")),
                ft.DataColumn(ft.Text("Stock")),
                ft.DataColumn(ft.Text("")),
                ft.DataColumn(ft.Text(""))],
        
            rows = [],
        
            )
        self.User = User



    def close_dlg(self, e: UserControl):
        e.page.close_dialog()
    
        
    def SaveChange(self, e:ControlEvent) -> None:
        NewName = self.ModifyName.value
        NewPrice = self.ModifyPrice.value
        NewStock = self.ModifyStock.value
        i = e.control.data
        df = pd.read_csv("objects/catalog.csv")
        df.loc[i,"ItemName"] = NewName
        df.loc[i,"ItemPrice"] = NewPrice
        df.loc[i,"ItemStock"] = NewStock
        df.to_csv("objects/catalog.csv",index=False)
        self.close_dlg(e)
        self.LoadItems()
        e.page.clean()
        e.page.update()
     
    def ModifyItem(self, e: ControlEvent) -> None:
        i = e.control.data
        df = pd.read_csv("objects/catalog.csv")
        self.ModifyName: TextField = TextField(label="Name",value=df["ItemName"][i])
        self.ModifyPrice: TextField = TextField(label="Price(PHP)",value=df["ItemPrice"][i])
        self.ModifyStock: TextField = TextField(label="Stock",value=df["ItemStock"][i])
        self.ModifyDialog: AlertDialog = AlertDialog(
            title=Text("Modify Item"),
            content=Column(controls =[self.ModifyName,
                                      self.ModifyPrice,self.ModifyStock]),
            actions=[TextButton("Save Changes",on_click=self.SaveChange,data=i),
                     TextButton("Cancel",on_click=self.close_dlg)],
            modal=True,
            )
        e.page.show_dialog(self.ModifyDialog)
        
    def RemoveItem(self,e:ControlEvent):
        i = e.control.data
        df = pd.read_csv('objects/catalog.csv')
        df = df.drop(e.control.data).reset_index(drop=True)
        df.to_csv('objects/catalog.csv',index=False)
        self.LoadItems()

        e.page.clean()
        e.page.update()   

        

    def LoadItems(self) -> None:
        df = pd.read_csv('objects/catalog.csv')
        self.ItemList.rows = []
        for item in df.index:
               self.ItemList.rows.append(ft.DataRow(cells=[ft.DataCell(ft.Text(df['ItemName'][item])),
                                                        ft.DataCell(ft.Text(df['ItemPrice'][item])),
                                                        ft.DataCell(ft.Text(df['ItemStock'][item])),
                                                        ft.DataCell(ft.ElevatedButton("Modify Item",data = item,on_click=self.ModifyItem)),
                                                        ft.DataCell(ft.ElevatedButton("Delete Item",data = item,on_click=self.RemoveItem))]))
    
    
    def build(self) -> Row:
        self.LoadItems()
        self.Scroll: Row = Row(controls = [self.ItemList],width=650,scroll=ScrollMode.ALWAYS)
        self.Scroll2: Column = Column(controls = [self.Scroll],height=300,scroll=ScrollMode.ALWAYS)
        return self.Scroll2
