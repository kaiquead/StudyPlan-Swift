//
//  StudyViewController.swift
//  PlanoDeEstudos
//
//  Created by Kaique Alves
//  Copyright © 2020 Kaique Alves. All rights reserved.

import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    let sm = StudyManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dpDate.minimumDate = Date()
        
    }

    @IBAction func schedule(_ sender: UIButton) {
        let id = String(Date().timeIntervalSince1970)
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        let content = UNMutableNotificationContent()
        content.title = "lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        
        //content.sound = UNNotificationSound(named: "arquivodesom.caf")
        content.categoryIdentifier = "Lembrete"
        
        //essa trigger é ativada depois dos 15 segundos a partir do momento da criação
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dpDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        sm.addPlan(studyPlan)
        navigationController?.popViewController(animated: true)
    }
    
}
