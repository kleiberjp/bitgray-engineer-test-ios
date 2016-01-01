# IOS App for Bitgray Test Engineer IOS #

This repository contains code IOS app for connect with app Bitgray Python REST Services
The data is consumed from the rest services of Python Django project
Used patter desing as MVC , extensions of controller IOS, used pod for library third

The project has e .json file that contains the urls of the rest services, and are readed by the app for consult the data

If want to export project in Xcode or AppCode (JetBrains) ide after open project
  
    cd <PATH TO PROJECT>/bitgray-ios
    pod install
  
Wait until install all library before

    open bitgray-ios.xcworspace
  
  
the project is constructed by the following path


    /..
      Services/..      /* Contains class for consumption of REST SERVICES */
      Models/..        /* Class for data of objects returned from REST services and use in all app */
      Config/..        /* Contains files need for save data locally an read urls services from json
      Extensions/..   /* Contains files for category extensions of class ios */
      UIControl/...   /* Views customized for apps */
      Controllers/..   /* All views for apps */
      
      
