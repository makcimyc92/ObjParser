//
//  SCNNode.swift
//  ObjParser
//
//  Created by Max Vasilevsky on 5/8/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    func rotateYForever(_ duration:TimeInterval = 1) {
        let action = SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: duration)
        runAction(SCNAction.repeatForever(action))
    }
    
}
