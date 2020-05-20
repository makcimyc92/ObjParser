//
//  ParseModels.swift
//  ObjParser
//
//  Created by Max Vasilevsky on 5/15/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import SceneKit

public struct ObjParserModel {
    var vertices = [SCNVector3]()
    var normals = [SCNVector3?]()
    var texturesCoord = [CGPoint?]()
    var groups = [Group]()
}

struct Face {
    var faceElement:[FaceElement]
}

struct FaceElement:Hashable {
    let vertexIndex:Int
    var normalIndex:Int? = nil
    var textureIndex:Int? = nil
}

struct Group {
    let name: String
    var faces: [Face]
    var faceElementCount = 0
    
    mutating func setup(_ count:Int) {
        faceElementCount = max(faceElementCount, count)
    }
}
