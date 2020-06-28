//
//  NotificationsTableViewController.swift
//  PlanoDeEstudos
//
//  Created by Kaique Alves
//  Copyright © 2020 Kaique Alves. All rights reserved.
//

import UIKit

class StudyPlansTableViewController: UITableViewController {
    
    let sm = StudyManager.shared
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(notification:)), name: NSNotification.Name(rawValue: "Confirmed"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func onReceive(notification: Notification){
        if let userInfo = notification.userInfo, let id = userInfo["id"] as? String{
            sm.setPlanDone(id: id)
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sm.studyPlans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let studyPlan = sm.studyPlans[indexPath.row]
        cell.textLabel?.text = studyPlan.section
        cell.detailTextLabel?.text = dateFormatter.string(from: studyPlan.date)
        
        //caso o studyPlan esteja como done deixa verda, senão deixa branco
        cell.backgroundColor = studyPlan.done ? .green : .white
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sm.removePlan(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }


}
