import Foundation
import SceneKit

// https://en.wikipedia.org/wiki/Wavefront_.obj_file

public class ObjParser<T: Sequence> where T.Iterator.Element == String {
    let v = "v "
    let vt = "vt "
    let vn = "vn "
    let f = "f "
    let o = "o "
    let slash:Character = "/"
    private var currentGroup: Group?

    private let source: T

    var model = ObjParserModel()

    public init(source: T) {
        self.source = source
    }
    
    public func parse() -> ObjParserModel {
        var faceElements = [FaceElement]()
        faceElements.reserveCapacity(3)
        for line in source {
            let scanner = Scanner(string: line)
            if line.hasPrefix(v) {
                scanner.offsetIndex(2)
                guard let x = scanner.scanFloat(),
                    let y = scanner.scanFloat(),
                    let z = scanner.scanFloat() else {
                        continue
                }
                let vertex = SCNVector3(x: x, y: y, z: z)
                self.model.vertices.append(vertex)
            } else if line.hasPrefix(vt) {
                scanner.offsetIndex(3)
                guard let u = scanner.scanFloat(),
                    let v = scanner.scanFloat() else {
                        continue
                }
                let point = CGPoint(x: CGFloat(u), y: CGFloat(v))
                self.model.texturesCoord.append(point)
            } else if line.hasPrefix(vn) {
                scanner.offsetIndex(3)
                guard let x = scanner.scanFloat(),
                    let y = scanner.scanFloat(),
                    let z = scanner.scanFloat() else {
                        continue
                }
                let vector = SCNVector3(x: x, y: y, z: z)
                self.model.normals.append(vector)
            } else if line.hasPrefix(f) {
                scanner.offsetIndex(2)
                faceElements.removeAll()
                while !scanner.isAtEnd {
                    guard let v = scanner.scanInt() else {
                        continue
                    }
                    var fElement = FaceElement(vertexIndex: v.dec())
                    if scanner.getNextChar() == slash {
                        scanner.offsetIndex(1)
                        if scanner.getNextChar() != slash {
                            fElement.textureIndex = scanner.scanInt()?.dec()
                        }
                        if scanner.getNextChar() == slash {
                            scanner.offsetIndex(1)
                            fElement.normalIndex = scanner.scanInt()?.dec()
                        }
                    }
                    faceElements.append(fElement)
                }
                if self.currentGroup == nil {
                    self.currentGroup = Group(name: "no name", faces: [])
                }
                let face = Face(faceElement: faceElements)
                self.currentGroup?.setup(faceElements.count)
                self.currentGroup?.faces.append(face)
            } else if line.hasPrefix(o) {
                scanner.offsetIndex(2)
                let name = line.suffix(line.count - 2).filter({!"\n".contains($0)})
                saveGroup()
                self.currentGroup = Group(name: String(name), faces: [])
            }
        }
        saveGroup()
        return model
    }
    
    func saveGroup() {
        if let g = self.currentGroup {
            self.model.groups.append(g)
        }
    }

}
