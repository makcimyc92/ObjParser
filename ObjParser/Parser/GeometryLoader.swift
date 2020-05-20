import SceneKit

typealias ParseGroupResult = (vertices:[SCNVector3], normals:[SCNVector3], textures:[CGPoint], element:SCNGeometryElement)

func parseModel(_ model:ObjParserModel) -> SCNGeometry {
    let vertices = model.vertices
    let normals = model.normals.compactMap{ $0 }
    let textures = model.texturesCoord.compactMap{ $0 }
    var elements = [SCNGeometryElement]()
    
    var sourceVertices = [SCNVector3]()
    var sourceNormals = [SCNVector3]()
    var sourceTexture = [CGPoint]()
    
    var indicesCount:Int32 = 0
    for group in model.groups {
        let result = parseGroup(group, vertices: vertices, normals: normals, textures: textures, indicesCount: &indicesCount)
        sourceVertices.append(contentsOf: result.vertices)
        sourceNormals.append(contentsOf: result.normals)
        sourceTexture.append(contentsOf: result.textures)
        elements.append(result.element)
    }
    return createGeometry(v: sourceVertices, n: sourceNormals, t: sourceTexture, e: elements)
}

func parseGeometriesModel(_ model:ObjParserModel) -> [SCNGeometry] {
    let vertices = model.vertices
    let normals = model.normals.compactMap{ $0 }
    let textures = model.texturesCoord.compactMap{ $0 }
    var geometries = [SCNGeometry]()
    var indicesCount:Int32 = 0
    for group in model.groups {
        indicesCount = 0
        let result = parseGroup(group, vertices: vertices, normals: normals, textures: textures, indicesCount: &indicesCount)
        let g = createGeometry(v: result.vertices, n: result.normals, t: result.textures, e: [result.element])
        geometries.append(g)
    }
    return geometries
}

func createGeometry(v:[SCNVector3], n:[SCNVector3], t:[CGPoint], e:[SCNGeometryElement]) -> SCNGeometry {
    let sVertices = SCNGeometrySource(vertices: v)
    let sNormals = SCNGeometrySource(normals: n)
    let sTextures = SCNGeometrySource(textureCoordinates: t)
    let geometry = SCNGeometry(sources: [sVertices, sTextures, sNormals], elements: e)
    return geometry
}

func parseGroup(_ group:Group,
                vertices:[SCNVector3],
                normals:[SCNVector3],
                textures:[CGPoint],
                indicesCount:inout Int32) -> ParseGroupResult {
    var sourceVertices = [SCNVector3]()
    var sourceNormals = [SCNVector3]()
    var sourceTexture = [CGPoint]()
    
    var indices = [Int32]()
    var indicesCache = [Int:Int32]()
    var primitiveType:SCNGeometryPrimitiveType
    if group.faceElementCount == 3 {
        primitiveType = .triangles
    } else {
        indices = Array.init(repeating: Int32(group.faceElementCount), count: group.faces.count)
        primitiveType = .polygon
    }
    for face in group.faces {
        for e in face.faceElement {
            let eHash = e.hashValue
            if let i = indicesCache[eHash] {
                indices.append(i)
            } else {
                indicesCache[eHash] = indicesCount
                indices.append(indicesCount)
                let v = vertices[e.vertexIndex]
                sourceVertices.append(v)
                if let index = e.normalIndex {
                    let n = normals[index]
                    sourceNormals.append(n)
                }
                if let index = e.textureIndex {
                    let n = textures[index]
                    sourceTexture.append(n)
                }
                indicesCount += 1
            }
        }
    }
    let primitiveCount = primitiveType == .polygon ? Int(indicesCount) / group.faceElementCount : indices.count / group.faceElementCount
    let data = Data(buffer: UnsafeBufferPointer(start: &indices, count: indices.count))
    let element = SCNGeometryElement(data: data,
                                     primitiveType: primitiveType,
                                     primitiveCount: primitiveCount,
                                     bytesPerIndex: MemoryLayout<Int32>.size)
    return (sourceVertices, sourceNormals, sourceTexture, element)
}

