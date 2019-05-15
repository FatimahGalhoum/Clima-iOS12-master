//
//  Extensions.swift
//  Clima
//
//  Created by Fatimah Galhoum on 5/15/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation


extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
