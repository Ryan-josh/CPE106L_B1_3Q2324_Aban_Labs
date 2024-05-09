from os import read
import flet as ft
import csv
from csv import writer
import pandas as pd
from flet import *
from flet_route import Params, Basket

class UserCart:
    def __init__(self):
        pass
    def Return(self,e:ControlEvent):
        df = pd.read_csv('objects/catalog.csv')
        df2 = pd.read_csv('objects/cart.csv')
        
        for item in df2.index:
            EditRow = df.loc[(df["ItemName"] == df2['CartItem'][item])]
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
        self.ViewCart: ElevatedButton = ElevatedButton(text='View Cart',width=200)
        self.Browse: ElevatedButton = ElevatedButton(text='Browse',width=200, on_click=lambda _: page.go(f"/usercatalog/{User}"))
        self.Checkout: ElevatedButton = ElevatedButton(text='Checkout',width=200,on_click=lambda _: page.go(f"/usercheckout/{User}"))
        self.Leave: ElevatedButton = ElevatedButton(text='Leave',width=200,bgcolor='RED_50',color='RED')
        self.Options = Column(controls=[self.logo,self.Greeting,self.Browse,self.ViewCart,self.Checkout,self.Leave])
        
        self.CartName = Text(value=f'Cart of {User}',weight=FontWeight.BOLD,size = 20)
        self.TheCart: Cart = Cart()
        self.TheCart.LoadCart()
        self.CartWindow = Column(controls=[self.CartName,self.TheCart])
        
        self.UserWindow = Row(controls=[self.Options,self.CartWindow])
    
        self.Leave.on_click = self.Return
        page.update()
 

        return View(
            "/usercart/:you_id",
            controls=[self.UserWindow]
                )
    
class Cart(UserControl):
    
    def __init__(self) -> None:
        super().__init__()
        self.CartList: DataTable = DataTable(
            columns =[
                ft.DataColumn(ft.Text("Item")),
                ft.DataColumn(ft.Text("Quantity")),
                ft.DataColumn(ft.Text("Price(PHP)")),
                ft.DataColumn(ft.Text(""))], 
        
            rows = [],
        
            )
 
        self.TotalItem: int = 0
        self.TotalPrice: float = 0
        
        
    def LoadCart(self) -> None:
        df = pd.read_csv('objects/cart.csv')
        self.TotalItem: int = 0
        self.TotalPrice: float = 0
        self.CartList.rows = []
        for item in df.index:
            self.CartList.rows.append(ft.DataRow(cells=[ft.DataCell(ft.Text(df['CartItem'][item])),
                                                        ft.DataCell(ft.Text(df['CartQuantity'][item])),
                                                        ft.DataCell(ft.Text(df['CartPrice'][item])),
                                                        ft.DataCell(ft.ElevatedButton("Remove from Cart",data=[item,df['CartItem'][item],df['CartQuantity'][item]],on_click=self.RemoveToCart))]))
            self.TotalItem = self.TotalItem + df['CartQuantity'][item]
            self.TotalPrice = self.TotalPrice + df['CartPrice'][item]
    
           
    def RemoveToCart(self,e:ControlEvent):
        df = pd.read_csv('objects/cart.csv')
        df = df.drop(e.control.data[0]).reset_index(drop=True)
        df.to_csv('objects/cart.csv',index=False)
        self.LoadCart()
        
        df = pd.read_csv('objects/catalog.csv')
        EditRow = df.loc[(df["ItemName"]==e.control.data[1])]
        df.loc[EditRow.index,'ItemStock'] = int(df['ItemStock'][EditRow.index]) + int(e.control.data[2])
        df.to_csv('objects/catalog.csv',index=False)
        
        

        e.page.clean()
        e.page.update()
        
    
    def build(self) -> Column:
        self.LoadCart()
        self.Scroll: Column = Column(controls = [self.CartList],height=250,scroll=ScrollMode.ALWAYS)
        self.Content: Container = Container(content=self.Scroll,border= border.all(1,"black"))
        self.ShowItem: TextField = TextField(value=f'No. of Item: {self.TotalItem}',read_only=True)
        self.ShowPrice: TextField = TextField(value=f'Total Price: PHP {self.TotalPrice}',read_only=True)
        self.CartInfo: Row = Row(controls=[self.ShowItem,self.ShowPrice])
        
        return Column(controls=[self.Content,self.CartInfo], alignment= MainAxisAlignment.CENTER)
         