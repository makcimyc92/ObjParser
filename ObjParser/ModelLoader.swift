import SceneKit

enum Models:String {
    case nanosuit
    case cube
}

typealias CompletionLoadModel = (SCNGeometry) -> ()
typealias CompletionLoadModels = ([SCNGeometry]) -> ()

final class ModelLoader {
    
    static func loadModel(_ model:Models, completion:@escaping CompletionLoadModel) {
        let parsedModel = parse(model)
        let geometry = parseModel(parsedModel)
        DispatchQueue.main.async {
            completion(geometry)
        }
    }
    
    static func loadModels(_ model:Models, completion:@escaping CompletionLoadModels) {
        DispatchQueue.global().async {
            let parsedModel = parse(model)
            let geometries = parseGeometriesModel(parsedModel)
            DispatchQueue.main.async {
                completion(geometries)
            }
        }
    }
    
    static private func parse(_ m:Models) -> ObjParserModel {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: m.rawValue, ofType: "obj") else {
            fatalError("File not found")
        }
        let reader = LineReader(path: path)!
        let parser = ObjParser(source: reader)
        let model = parser.parse()
        return model
    }
}



