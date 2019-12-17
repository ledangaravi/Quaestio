//
//  time.swift
//  Questio
//
//  Created by Rahul Berry on 20/11/2019.
//  Copyright © 2019 rberry. All rights reserved.
//

import Foundation

class backendFunctions {
    public func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
}
