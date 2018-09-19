web后端管理
####################

在poppy.alv.pub:8080 上部署了我们的django项目后，我们可以通过poppy.alv.pub:8080/admin 这个页面来管理我们的数据库。


在上一章数据库操作中我们进行了如下操作：

::

    # vim User/admin.py
    from django.contrib import admin
    from User.models import *

    # Register your models here.
    class UserAdmin(admin.ModelAdmin):
        list_display = ['name','email']
        search_fields = ['age']
    admin.site.register(User,UserAdmin)


这个操作之后，我们在poppy.alv.pub:8080/admin  就可以看到我们在上面的操作中写的要显示的字段，以及搜索的字段。

在这个界面，可以增删查改数据。