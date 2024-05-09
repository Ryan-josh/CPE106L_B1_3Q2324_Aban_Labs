import flet as ft
import csv
from csv import writer
import pandas as pd
from flet import *
from flet_route import Params, Basket

class UserCatalog:
    def __init__(self):
        super().__init__()
        pass
    def Return(self,e:ControlEvent):
        
        df = pd.read_csv('objects/catalog.csv')
        df2 = pd.read_csv('objects/cart.csv')
        
        for item in df2.index:
            Return = df2.loc[item,'CartItem']
            EditRow = df.loc[(df["ItemName"] == Return)]
            df.loc[EditRow.index,'ItemStock'] = int(df['ItemStock'][EditRow.index]) + int(df2['CartQuantity'][item])

        df.to_csv('objects/catalog.csv',index=False)

        ClearCart = open("objects/cart.csv",'w')
        ClearCart.truncate()
        ClearCart.close()
        
        with open('objects/cart.csv', 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['CartItem', 'CartQuantity', 'CartPrice'])
            
        e.page.go("/")
    

        

    def view(self, page: Page, params: Params, basket:Basket):
        User = params.get("you_id")
        self.logo: Image = Image(src='objects/MapuMartLogo.png',height=150,width=200,fit=ft.ImageFit.SCALE_DOWN)
        self.Greeting = Text(value=f'Welcome: {User}',weight=FontWeight.BOLD)
        self.ViewCart: ElevatedButton = ElevatedButton(text='View Cart',width=200, on_click=lambda _: page.go(f"/usercart/{User}"))
        self.Browse: ElevatedButton = ElevatedButton(text='Browse',width=200)
        self.Checkout: ElevatedButton = ElevatedButton(text='Checkout',width=200,on_click=lambda _: page.go(f"/usercheckout/{User}"))
        self.Leave: ElevatedButton = ElevatedButton(text='Leave',width=200,bgcolor='RED_50',color='RED')
        self.Options = Column(controls=[self.logo,self.Greeting,self.Browse,self.ViewCart,self.Checkout,self.Leave])
        
        self.SearchField: SearchBar = SearchBar(width=600)
        self.SearchResult: Catalog = Catalog(User)
        self.SearchWindow = Column(controls=[self.SearchField,self.SearchResult],alignment=ft.MainAxisAlignment.CENTER)
        
        self.UserWindow = Row(controls=[self.Options,self.SearchWindow])
    
        self.Leave.on_click = self.Return
        
        page.window_height = 425
        page.window_width = 900
        page.window_center()
        
        
        page.update()
 

        return View(
            "/usercatalog/:you_id",
            controls=[self.UserWindow]
                )

class Catalog(UserControl):
    
    def __init__(self,User:str) -> None:
        super().__init__()
        self.ItemList: DataTable = DataTable(
            columns =[
                ft.DataColumn(ft.Text("Item")),
                ft.DataColumn(ft.Text("Price(PHP)")),
                ft.DataColumn(ft.Text("Stock")),
                ft.DataColumn(ft.Text(""))], 
        
            rows = [],
        
            )
        self.User = User



    def close_dlg(self, e: UserControl):
        e.page.close_dialog()
    
    def decrement(self, e: ControlEvent) -> None:
        if int(self.SetQuantity.value) > 0:
            self.SetQuantity.value = str(int(self.SetQuantity.value)-1)
        e.page.dialog.update()

    
    def increment(self, e: ControlEvent) -> None:
        df = pd.read_csv('objects/catalog.csv')
        stock = int(df['ItemStock'][e.control.data])
        if int(self.SetQuantity.value) < stock:
            self.SetQuantity.value = str(int(self.SetQuantity.value)+1)
        e.page.dialog.update()
    
    def AddToCart(self, e: ControlEvent):
       NewPrice = self.RetrivePrice * float(self.SetQuantity.value)
       NewItem = [self.RetrivedName,self.SetQuantity.value,NewPrice]
       with open ('objects/cart.csv','a') as AppendCatalog:
           writerCatalog = writer(AppendCatalog)
           writerCatalog.writerow(NewItem)
           AppendCatalog.close()
       
       df = pd.read_csv('objects/catalog.csv')
       df.loc[e.control.data,'ItemStock'] = int(df['ItemStock'][e.control.data]) - int(self.SetQuantity.value)
       df.to_csv('objects/catalog.csv',index=False)
       self.close_dlg(e)
       self.LoadItems()
       e.page.clean()
       e.page.update()
        

     
    def RetrieveItem(self, e: ControlEvent) -> None:
        self.RetrivedName = e.control.data[0]
        self.RetrivePrice = e.control.data[1]
        self.ShowName = Text(f"Item Name: {self.RetrivedName}")
        self.ShowPrice = Text(f"Item Price: PHP {self.RetrivePrice}")
        self.SetQuantity: TextField = TextField(value="0",text_align = ft.TextAlign.RIGHT,width=100)
        self.Counter: Row = Row(
        [ft.IconButton(ft.icons.REMOVE, on_click=self.decrement),self.SetQuantity,ft.IconButton(ft.icons.ADD, on_click=self.increment,data=e.control.data[2])]
        ,alignment =ft.MainAxisAlignment.CENTER
        )
        self.Test: AlertDialog = AlertDialog(title=ft.Text("Set Quantity"),content=ft.Column(controls=[self.ShowName,self.ShowPrice,self.Counter]),actions=[
        ft.TextButton("Add to Cart", on_click=self.AddToCart,data=e.control.data[2]),
        ft.TextButton("Cancel", on_click=self.close_dlg,style=ButtonStyle(color='red'))
        ])
        e.page.show_dialog(self.Test)

        

    def LoadItems(self) -> None:
        df = pd.read_csv('objects/catalog.csv')
        self.ItemList.rows = []
        for item in df.index:
            if df['ItemStock'][item] == 0:
               self.ItemList.rows.append(ft.DataRow(cells=[ft.DataCell(ft.Text(df['ItemName'][item])),
                                                        ft.DataCell(ft.Text(df['ItemPrice'][item])),
                                                        ft.DataCell(ft.Text(df['ItemStock'][item])),
                                                        ft.DataCell(ft.ElevatedButton("Add to Cart",disabled=True))]))
            else:
                self.ItemList.rows.append(ft.DataRow(cells=[ft.DataCell(ft.Text(df['ItemName'][item])),
                                                        ft.DataCell(ft.Text(df['ItemPrice'][item])),
                                                        ft.DataCell(ft.Text(df['ItemStock'][item])),
                                                        ft.DataCell(ft.ElevatedButton("Add to Cart",on_click=self.RetrieveItem,data=[df['ItemName'][item],df['ItemPrice'][item],item]))]))
    
    def AddItem(str, newName: str, newPrice: float, newStock: int):
       NewItem = [newName,newPrice,newStock]
       with open ('objects/catalog.csv','a') as AppendCatalog:
           writerCatalog = writer(AppendCatalog)
           writerCatalog.writerow(NewItem)
           AppendCatalog.close()
           
    def RemoveItem(self,removeName: str):
        df = pd.read_csv('objects/catalog.csv.csv')
        df = df.drop(df[df.ItemName == removeName].index)
        df.to_csv('objects/catalog.csv.csv')
        
    def UpdateItem(self,updateName:str,updatePrice:float,updateStock:int):
        df = pd.read_csv('objects/catalog.csv.csv')
        EditRow = df.get_loc(updateName)
        df.loc[EditRow] = [updateName,updatePrice,updateStock]
        df.to_csv('objects/catalog.csv.csv',index = False)
    
    def build(self) -> Column:
        self.LoadItems()
        self.Scroll: Column = Column(controls = [self.ItemList],height=300,scroll=ScrollMode.ALWAYS)
        return self.Scroll
