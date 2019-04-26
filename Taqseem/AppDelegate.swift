//
//  AppDelegate.swift
//  MaakMaak
//
//  Created by M on 2/5/19.
//  Copyright © 2019 M. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import UserNotifications
var GIsAtChatRoom = false
var GIsNotification = false
var GisNewnotification = false
var GisAcceptNotification = false
var GnotificationMsg : NotificationModelClass!
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{
    var window: UIWindow?
    var notificationmsg : NotificationModelClass!
    var notificationWas = false
  let googleMapsApiKey = "AIzaSyBtYiI25jiKYa76mtRT78BAUsFs_IHyTPw"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /////
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized:Bool, error:Error?) in
            if !authorized {
                print("App is useless because you did not allow notifications.")
            }
        }
        
        
        // Define Actions
        let fruitAction = UNNotificationAction(identifier: "addFruit", title: "Add a piece of fruit", options: [])
        let vegiAction = UNNotificationAction(identifier: "addVegetable", title: "Add a piece of vegetable", options: [])
        
        
        // Add actions to a foodCategeroy
        let category = UNNotificationCategory(identifier: "foodCategory", actions: [fruitAction, vegiAction], intentIdentifiers: [], options: [])
        
        // Add the foodCategory to Notification Framwork
        UNUserNotificationCenter.current().setNotificationCategories([category])
        return true
    }
    
    
    //////////
    
    func scheduleNotification(message : MessageModelClass) {
        //notificationmsg = message
        UNUserNotificationCenter.current().delegate = self
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = message._username
        content.body = message._message
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = message._id
        guard let path = Bundle.main.path(forResource: "Apple", ofType: "png") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        }catch{
            print("The attachment could not be loaded")
        }
        
        let request = UNNotificationRequest(identifier: "foodNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func scheduleNotification(message : NotificationModelClass) {
        notificationmsg = message
        UNUserNotificationCenter.current().delegate = self
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = message._from
        content.body = message._msg
        content.sound = UNNotificationSound.default
        //content.categoryIdentifier = message._type_id
        //guard let path = Bundle.main.path(forResource: "Apple", ofType: "png") else {return}
        //let url = URL(fileURLWithPath: path)
        
       // do {
         //   let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
        //    content.attachments = [attachment]
       // }catch{
         //   print("The attachment could not be loaded")
       // }
        
        let request = UNNotificationRequest(identifier: "foodNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(notificationmsg._type)
        let NotificationType = notificationmsg._type
        GnotificationMsg = notificationmsg
        if NotificationType == "new_reservation"{
            GisNewnotification = true
            let delegate = UIApplication.shared.delegate as! AppDelegate
            //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
            let storyboard = UIStoryboard.init(name: "Owner", bundle: nil);
            delegate.window?.rootViewController =
                storyboard.instantiateInitialViewController()
        }
        else if NotificationType == "accept_reservation"{
            GisAcceptNotification = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchesTableVC")as! MyMatchesTableVC
            let currentController = self.getCurrentViewController()
                        currentController?.present(cont, animated: true, completion: nil)
            
        }
        else if NotificationType == "reject_reservation"{
            GisAcceptNotification = true
            let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
            let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchesTableVC")as! MyMatchesTableVC
            let currentController = self.getCurrentViewController()
            currentController?.present(cont, animated: true, completion: nil)
        }
        else if NotificationType == "user_message"{
            GIsNotification = true
            let SelectedPlay = User(
                                    user_id : GnotificationMsg._type_id ,
                                    from : GnotificationMsg._from
                                )
            
                                print(SelectedPlay.user_id)
            
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Chat", bundle:nil)
                                let cont = storyBoard.instantiateViewController(withIdentifier: "ChatpageVC")as! ChatpageVC
                                print(SelectedPlay)
                                cont.SelectedPlayer = SelectedPlay
            let currentController = self.getCurrentViewController()
                       currentController?.present(cont, animated: true, completion: nil)
            
            
           
        
        }
        else if NotificationType == "group_message"{
            GIsNotification = true
            let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
            let cont = storyBoard.instantiateViewController(withIdentifier: "ChatRoomVC")as! ChatRoomVC
            cont.comefromFilter = false
            cont.GroupID = notificationmsg._type_id
            let currentController = self.getCurrentViewController()
            currentController?.present(cont, animated: true, completion: nil)
        }
        else{
            print("Unknown Notification")
        }
       
        //scheduleNotification(message: notificationmsg)
        
        completionHandler()
        
    }
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    //////////////
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if GIsAtChatRoom == false{
            notificationWas = false
        }else{
            notificationWas = true
            GIsAtChatRoom = false
        }
        SocketManger.shared.connect()
//        SocketManger.shared.handleNewMessage { (message) in
//        }
        SocketManger.shared.handleNotificationMessage { (message) in
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if notificationWas == false{
            GIsAtChatRoom = false
        }else{
            GIsAtChatRoom = true
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //SocketManger.shared.connect()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
//
//notification channel
//notification
//    {
//        msg:"",
//        type:"",
//        type_id:"",
//        from:""
//}
//msg->message
//type (new_reservation,accept_reservation,reject_reservation,user_message,group_message)
//if type=user_message type_id=user_id
//if type=group_message type_id=group_id
//if type =new_reservation,accept_reservation,reject_reservation type_id=reservation_id
//from send notification name
