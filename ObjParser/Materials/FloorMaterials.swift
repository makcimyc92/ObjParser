//
//  FloorMaterials.swift
//  ObjParser
//
//  Created by Max Vasilevsky on 5/8/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import SceneKit

final class FloorMaterial: SCNMaterial {
    override init() {
        super.init()
        diffuse.wrapS = .repeat
        diffuse.wrapT = .repeat
        
        normal.contents = UIColor.lightGray
        normal.intensity = 0.4
        
        selfIllumination.contents = UIColor.black
        selfIllumination.intensity = 0.3
        
        ambient.contents = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1)
        specular.contents = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
