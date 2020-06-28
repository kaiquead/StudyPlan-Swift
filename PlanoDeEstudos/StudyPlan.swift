//
//  StudyPlan.swift
//  PlanoDeEstudos
//
//  Created by Kaique Alves on 27/06/20.
//  Copyright © 2020 Kaique Alves. All rights reserved.
//

import Foundation

class StudyPlan: Codable{
    let course: String
    let section: String
    let date: Date
    var done: Bool
    var id: String
    
    init(course: String, section: String, date: Date, done: Bool, id: String) {
        self.course = course
        self.section = section
        self.date = date
        self.done = done
        self.id = id
    }
}
