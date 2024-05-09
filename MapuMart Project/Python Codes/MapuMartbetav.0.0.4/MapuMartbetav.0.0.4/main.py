
import flet as ft
from flet import *
from flet_route import Routing, path
from login import Login
from usercatalog import UserCatalog
from usercart import UserCart
from usercheckout import UserCheckout
from adminlogin import AdminLogin
from admincatalog import AdminCatalog
from admintransaction import ViewTransactions
def main(page: Page):
    page.title = 'MapuMart Bete Version 0.0.3'
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 400
    page.window_height = 400
    
    app_routes = [
        path(url="/",clear=True,view=Login().view),
        path(url="/usercatalog/:you_id",clear=True,view=UserCatalog().view),
        path(url="/usercart/:you_id",clear=True,view=UserCart().view),
        path(url="/usercheckout/:you_id",clear=True,view=UserCheckout().view),
        path(url="/adminlogin/:you_id",clear=True,view=AdminLogin().view),
        path(url="/admincatalog/:you_id",clear=True,view=AdminCatalog().view),
        path(url="/admintransaction/:you_id",clear=True,view=ViewTransactions().view)]
    
    Routing(page=page,app_routes=app_routes)
    page.go(page.route)

ft.app(target=main)
