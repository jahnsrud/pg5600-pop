//
//  DurationFormatter.swift
//  Pop
//
//  Created by Markus Jahnsrud on 01/11/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

extension Int {
    func convertMillisecondsToHumanReadable() -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(self) / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        
        return "\(formatter.string(from: date as Date))"
        
    }
}
