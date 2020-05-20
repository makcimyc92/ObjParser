import UIKit
import SceneKit

class GameViewController: UIViewController {
    var scene = SCNScene()
    var modelNode = SCNNode()
    var cameraNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloor()
        setupView()
        setupCamera()
        setupLightNode()
    }
    
    lazy var nanoBtn:UIButton? = { [weak self] in
        let btn = UIButton(type: .system)
        btn.setTitle("Load Nanasuit", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(handleNanoButton), for: .touchUpInside)
        self?.view.addSubview(btn)
        return btn
    }()
    
    lazy var cubeBtn:UIButton? = { [weak self] in
        let btn = UIButton(type: .system)
        btn.setTitle("Load cube", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(handleCubeButton), for: .touchUpInside)
        self?.view.addSubview(btn)
        return btn
    }()
    
    @objc func handleNanoButton() {
        loadModel(.nanosuit)
    }
    
    @objc func handleCubeButton() {
        loadModel(.cube)
    }
    
    func loadModel(_ model:Models) {
        ModelLoader.loadModel(model) { [weak self] (g) in
            self?.addNodeWith(g, xOffset: 4, rotate: true)
        }
        ModelLoader.loadModels(model) { [weak self] (g) in
            g.enumerated().forEach { (i) in
                let m = SCNMaterial()
                var rotate = true
                switch i.offset {
                    case 0:
                        m.diffuse.contents = UIColor.green
                    case 1,5:
                        m.diffuse.contents = UIColor.red
                    default:
                    rotate = false
                }
                i.element.materials = [m]
                self?.addNodeWith(i.element, xOffset: -4, rotate: rotate)
            }
        }
    }
    
    func addNodeWith(_ g:SCNGeometry, xOffset:Float, rotate:Bool) {
        let c = SCNNode()
        c.geometry = g
        c.position = SCNVector3(xOffset, 1, 0)
        scene.rootNode.addChildNode(c)
        if rotate {
            c.rotateYForever()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nanoBtn?.center = CGPoint(x: 80, y: 60)
        cubeBtn?.center = CGPoint(x: view.bounds.width - 60, y: 60)
    }

    private func setupFloor() {
        let floor = SCNFloor()
        floor.materials = [FloorMaterial()]
        floor.reflectivity = 0.1
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(floorNode)
    }

    func setupView() {
        let v = view as? SCNView
        v?.scene = scene
        v?.allowsCameraControl = true
        v?.backgroundColor = .white
//        v?.autoenablesDefaultLighting = true
    }

    func setupCamera() {
        let camera = SCNCamera()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 10, 20)
        scene.rootNode.addChildNode(cameraNode)
    }

    func setupLightNode() {
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = .omni
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 100, z: 10)
        scene.rootNode.addChildNode(lightNode)
    }

}
