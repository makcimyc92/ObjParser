//
//  Scanner.swift
//  ObjParser
//
//  Created by Max Vasilevsky on 5/15/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import Foundation

extension Scanner {
    func offsetIndex(_ offset:String.IndexDistance) {
        currentIndex = string.index(currentIndex, offsetBy: offset)
    }
    
    func getNextChar() -> Character {
        string[currentIndex]
    }
}
