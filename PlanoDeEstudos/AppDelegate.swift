//
//  AppDelegate.swift
//  PlanoDeEstudos
//
//  Created by Kaique Alves
//  Copyright © 2020 Kaique Alves. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor(named: "main")
        
        center.delegate = self
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
                self.center.requestAuthorization(options: options) { (sucess, error) in
                    if error == nil {
                        print(sucess)
                    } else{
                        print(error!.localizedDescription)
                    }
                }
            } else if settings.authorizationStatus == .denied{
                print("Usuário negou a notificação")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Já estudei", options: [.foreground])
        //.foreground é uma opção para que o app abra caso ele tenha clicado nesse botão
        
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder:"", options: [.customDismissAction])
        //customDismissAction serve para sabermos caso o usuário tenha dispensado
        
        center.setNotificationCategories([category])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    //essa funcao serve para mostrar uma notificacao mesmo que o usuario ja esteja no app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    //essa funcao serve para sabermos qual foi a acao que o usuario tocou para escolhermos o que fazer depois
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive response")
        
        let id = response.notification.request.identifier
        print(id)
        
        switch response.actionIdentifier {
        case "Confirm":
            print("Usuário confirmou que já estudou a matéria")
            
            //Manda uma notificacao depois de uma ação e a classe que estiver ouvindo essa NotificationCenter pode tomar uma ação
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Confirmed"), object: nil, userInfo: ["id": id])
        case "Cancel":
            print("Usuário cancelou")
        case UNNotificationDefaultActionIdentifier:   //isso é disparado quando ele clica na propria notificação, em cima dela mesmo
            print("Tocou na própria notificação")
        case UNNotificationDismissActionIdentifier:
            print("Dismiss na notificação")
        default:
            break
        }
        
        completionHandler()
    }
}
