import flet as ft
import pandas as pd
from flet import *
from flet_route import Routing, path, Params,Basket
from usercatalog import UserCatalog

class AdminLogin:
    
    
    def __init__(self):
        pass
    
    def validate(self,e: ControlEvent) -> None:
        if all(self.admin_password.value):
                self.button_Submit.disabled = False
        else:
            self.button_Submit.disabled = True
        
        e.page.update()
        
        
        
    def submit(self, e: ControlEvent) -> None:

        if self.AdminPass == self.admin_password.value:
            e.page.go(f"/admincatalog/{self.AdminIndex}")

            
        else:
            e.page.show_dialog(AlertDialog(title=ft.Text("Wrong Password"),on_dismiss=lambda _: e.page.go("/")))
            
            

    def view(self,page: Page, params:Params,basket: Basket):
        
        self.AdminIndex = int(params.get("you_id"))
        AdminAccounts = pd.read_csv("objects/admin.csv")
        self.AdminName = AdminAccounts["AdminName"][self.AdminIndex]
        self.AdminPass = AdminAccounts["AdminPass"][self.AdminIndex]

        self.admin_password: TextField = TextField(label='Enter Password . . .',text_align=ft.TextAlign.LEFT, width = 400)
        self.button_Submit: ElevatedButton = ElevatedButton(text='Login',width=200, disabled=True)
        self.text_welcome: Text = Text(value='Admin Login',size=30)
        self.logo: Image = Image(src='objects/MapuMartLogo.png',height=150,width=200,fit=ft.ImageFit.SCALE_DOWN)
        self.admin_password.on_change = self.validate
        self.button_Submit.on_click = self.submit
        self.button_Submit.disabled = True
        return View(
            "/adminlogin/:you_id",
            controls=[
                Row(
              controls=[Column([self.logo,self.text_welcome,self.admin_password,self.button_Submit],horizontal_alignment=ft.CrossAxisAlignment.CENTER)],
              alignment=ft.MainAxisAlignment.CENTER
              )
                ]
        )
