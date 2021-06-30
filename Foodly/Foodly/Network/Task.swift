//
//  Task.swift
//  Foodly
//
//  Created by Decagon on 6/5/21.
//

import Foundation

enum Tasks {
    case read
    case delete
    case create(documentData: Parameter)
    case update(documentData: Parameter)
}
