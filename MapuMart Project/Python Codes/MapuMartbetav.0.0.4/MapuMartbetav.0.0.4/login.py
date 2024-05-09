from pickle import FALSE
import flet as ft
import pandas as pd
from flet import *
from flet_route import Routing, path, Params,Basket
from usercatalog import UserCatalog

class Login:
    
    
    def __init__(self):
        super().__init__()
        self.AdminAccounts = pd.read_csv("objects/admin.csv")
        self.text_username: TextField = TextField(label='Enter Customer Name . . .',text_align=ft.TextAlign.LEFT, width = 400)
        self.button_Submit: ElevatedButton = ElevatedButton(text='Start Shopping',width=200, disabled=True)
        self.text_welcome: Text = Text(value='Welcome to MapuMart!',size=30)
        self.logo: Image = Image(src='objects/MapuMartLogo.png',height=150,width=200,fit=ft.ImageFit.SCALE_DOWN)
    
    def validate(self,e: ControlEvent) -> None:
        if all(self.text_username.value):
                self.button_Submit.disabled = False
        else:
            self.button_Submit.disabled = True
        
        e.page.update()
        
        
        
    def submit(self, e: ControlEvent) -> None:
        
        CheckAdmin = self.AdminAccounts.loc[(self.AdminAccounts["AdminName"]==self.text_username.value)]
        if CheckAdmin.empty == True:
            UserName = self.text_username.value
            e.page.go(f"/usercatalog/{UserName}")
            
        else:
            UserName = int(CheckAdmin.index.values)
            e.page.go(f"/adminlogin/{UserName}")
            
            

    def view(self,page: Page, params:Params,basket: Basket):
        
        page.window_width = 450
        page.window_height = 375
        page.window_center()
        page.window_resizable = False
        page.window_maximizable = False
        page.vertical_alignment = MainAxisAlignment.CENTER
        
        self.text_username.on_change = self.validate
        self.button_Submit.on_click = self.submit
        self.text_username.value = ""
        self.button_Submit.disabled = True
        return View(
            "/",
            controls=[
                Row(
              controls=[Column([self.logo,self.text_welcome,self.text_username,self.button_Submit],horizontal_alignment=ft.CrossAxisAlignment.CENTER)],
              alignment=MainAxisAlignment.CENTER
              )
                ]
        )