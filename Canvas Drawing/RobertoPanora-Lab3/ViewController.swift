//
//  ViewController.swift
//  RobertoPanora-Lab3
//
//  Created by Roberto Panora on 10/3/23.
//

import UIKit
import Photos

enum Action: Int {
    case d = 0
    case m = 1
    case e = 2
}

enum Color: String {
    case r = "red"
    case b = "blue"
    case g = "green"
    case p = "purple"
    case o = "orange"
    case null = ""
}

enum CurrentShape: String {
    case rect = "rectangle"
    case tri = "triangle"
    case circ = "circle"
}

enum ShapeFill: String {
    case out = "Outline"
    case sol = "Solid"
}

//enum ImportItem: String {
//    case back = "background"
//    case draw = "drawing"
//}



class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func requestPhotoLibraryPermission() {
           PHPhotoLibrary.requestAuthorization { status in
               switch status {
               case .authorized:
                   break;
               case .denied, .restricted:
                   return
               case .notDetermined:
                   while(status != .authorized){
                       print("waiting for permission")
                   }
                   break;
               case .limited:
                   print("ok")
               @unknown default:
                   break
               }
           }
       }
    
    var drawingNames: [String] = ["Blank"];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDrawings.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = drawingNames[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let template = tableView.cellForRow(at: indexPath)?.textLabel!.text;
        print(template!)
        if template != "Blank"{
            drawingView.items = savedDrawings[template!]!
            createdShapes =  savedDrawings[template!]!
        }
        else {
            drawingView.items = [];
            createdShapes = [];
        }
    }
    
    @IBOutlet weak var drawingTable: UITableView!
    
    
    @IBOutlet weak var drawingName: UITextField!
    
    @IBOutlet weak var drawingView: DrawingView!
    
    @IBOutlet weak var fillSwitchLabel: UILabel!
    @IBOutlet weak var fillOutlineSwitch: UISwitch!
    
    @IBOutlet weak var actionControl: UISegmentedControl!
    
    @IBOutlet weak var rectButton: UIButton!
    @IBOutlet weak var circButton: UIButton!
    @IBOutlet weak var triButton: UIButton!
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet var rotateGesture: UIRotationGestureRecognizer!
    
    
    @IBOutlet weak var red: ColorButton!;
    @IBOutlet weak var blue: ColorButton!;
    @IBOutlet weak var green: ColorButton!
    @IBOutlet weak var purple: ColorButton!
    @IBOutlet weak var orange: ColorButton!
    
    
    var color: Color = .null;
    var shape: CurrentShape = .rect;
    var action: Action = .d;
    
    var selectedShape: Shape? = nil;
    
    var backgroundImage: UIImage?;
    var savedDrawings: [String:[Shape]] = [:]
    
    var createdShapes:[Shape] = [];
    var shapeFill: ShapeFill = .out;
    
    override func viewDidLoad() {
        if backgroundImage != nil{
            drawingView.makeBackgroundImage(image: backgroundImage)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        red.setup(c: UIColor.red, colorName: .r);
        blue.setup(c: UIColor.blue, colorName: .b);
        green.setup(c: UIColor.green, colorName: .g);
        purple.setup(c: UIColor.purple, colorName: .p);
        orange.setup(c: UIColor.orange, colorName: .o);
        rectButton.backgroundColor = UIColor.darkGray;
        circButton.backgroundColor = UIColor.gray;
        triButton.backgroundColor = UIColor.gray;
        rotateGesture.delegate = self;
        pinchGesture.delegate = self;
        drawingTable.delegate = self;
        drawingTable.dataSource = self;
        self.savedDrawings["Blank"] = [];
    }
    
    
    @IBAction func `import`(_ sender: UIButton) {
        imageSelector()
    }
    
    
    
    func imageSelector() {
        let chosenImage = UIImagePickerController();
        chosenImage.sourceType = .photoLibrary;
        chosenImage.delegate = self;
        self.present(chosenImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let getImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            drawingView.makeBackgroundImage(image: getImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        requestPhotoLibraryPermission()
        let temp = createdShapes
        let newImage = drawingView.convertToImage();
        let saveAlert = UIAlertController(title: "Enter Image Name", message: "Example: Puppy:", preferredStyle: .alert)
        saveAlert.addTextField { text in
            text.placeholder = "Name"
        }
        
        let save = UIAlertAction(title: "SAVE", style: .default) { _ in
            if let text = saveAlert.textFields?.first, let userText = text.text {
                self.savedDrawings[userText] = temp;
                self.drawingNames.append(userText)
                self.drawingTable.reloadData()
            }
        }
        saveAlert.addAction(save)
        present(saveAlert, animated: true, completion: nil)
        drawingView.items = []
        createdShapes = []
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // any time touches the screen
        guard touches.count == 1, let touchPoint = touches.first?.location(in: drawingView) else { return }
        
        switch action {
        case .d:
            if(color != .null){
                let newColor: UIColor = getColor(cName:color);
                if(shapeFill == .out){
                    switch shape {
                    case .rect:
                        let newShape = OutlineRectangle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    case .circ:
                        let newShape = OutlineCircle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    default:
                        let newShape = OutlineTriangle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    }
                }
                else{
                    switch shape {
                    case .rect:
                        let newShape = SolidRectangle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    case .circ:
                        let newShape = SolidCircle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    default:
                        let newShape = SolidTriangle(origin: touchPoint, color: newColor);
                        createdShapes.append(newShape);
                        break;
                    }
                }
                
            }
            break;
        case .m:
            let drawingItem = drawingView.itemAtLocation(touchPoint);
            if(drawingItem != nil) {
                selectedShape = drawingItem as? Shape;
            }
            break;
        case .e:
            let drawingItem = drawingView.itemAtLocation(touchPoint);
            if(drawingItem != nil) {
                let shapeAtLocation: Shape = drawingItem as! Shape;
                shapeAtLocation.shapePath.removeAllPoints();
                let removeIndex: Int = createdShapes.lastIndex(where: {$0 === shapeAtLocation}) ?? -1;
                createdShapes.remove(at: removeIndex);
            }
            break;
        }
        drawingView.items = createdShapes;
        print("Began at: \(touchPoint)");
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touchPoint = touches.first?.location(in: drawingView) else { return}
        
        print(touches.count)
        if(selectedShape != nil && action == .m && (rotateGesture.state != .began || rotateGesture.state != .changed) && (pinchGesture.state != .began || pinchGesture.state != .changed)){
            let moveIndex: Int = createdShapes.lastIndex(where: {$0 === selectedShape}) ?? -1;
            
            selectedShape?.shapePath.movePath(oldOrigin: selectedShape!.origin, newOrigin: touchPoint);
            selectedShape?.origin = touchPoint;
            
            createdShapes[moveIndex] = selectedShape!;
            print("here")
        }
        
        drawingView.items = createdShapes;
        print("Moved to: \(touchPoint)");
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touchPoint = touches.first?.location(in: drawingView) else { return }
        selectedShape = nil;
        print("Ended at: \(touchPoint)");
    }
    
    @IBAction func changeAction(_ sender: UISegmentedControl) {
        switch actionControl.selectedSegmentIndex {
        case 0:
            action = .d;
            selectedShape = nil;
            break;
        case 1:
            action = .m;
            break;
        case 2:
            action = .e;
            selectedShape = nil;
            break;
        default: break;
        }
    }
    //piazza
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        if(selectedShape != nil && action == .m){
            let moveIndex: Int = createdShapes.lastIndex(where: {$0 === selectedShape}) ?? -1;
            let s = sender.scale/selectedShape!.scale;
            selectedShape!.shapePath.scaleAroundCenter(factor: s);
            selectedShape?.scale = sender.scale;
            createdShapes[moveIndex] = selectedShape!;
            drawingView.items = createdShapes;
        }
        
    }
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        if(selectedShape != nil && action == .m){
            let moveIndex: Int = createdShapes.lastIndex(where: {$0 === selectedShape}) ?? -1;
            selectedShape?.shapePath.rotate(by: sender.rotation)
            createdShapes[moveIndex] = selectedShape!;
            drawingView.items = createdShapes;
            sender.rotation = 0;
        }
    }
    
    
    @IBAction func changeToRectangle(_ sender: UIButton) {
        shape = .rect;
        rectButton.backgroundColor = UIColor.darkGray;
        circButton.backgroundColor = UIColor.gray;
        triButton.backgroundColor = UIColor.gray;
    }
    @IBAction func changeToCircle(_ sender: UIButton) {
        shape = .circ
        rectButton.backgroundColor = UIColor.gray;
        circButton.backgroundColor = UIColor.darkGray;
        triButton.backgroundColor = UIColor.gray;
    }
    
    @IBAction func changeToTriangle(_ sender: UIButton) {
        print(drawingView.items.count)
        shape = .tri;
        rectButton.backgroundColor = UIColor.gray;
        circButton.backgroundColor = UIColor.gray;
        triButton.backgroundColor = UIColor.darkGray;
    }
    
    @IBAction func clearAll(_ sender: Any) {
        //come back here to see if necessary
        selectedShape = nil;
        createdShapes.forEach { s in
            s.shapePath.removeAllPoints();
        }
        backgroundImage = UIImage();
        drawingView.backgroundColor = UIColor.darkGray;
        createdShapes.removeAll();
        drawingView.items = createdShapes;
        resetColorButton(button: color);
        color = Color.null;
    }
    
    @IBAction func clickedColor(_ sender: ColorButton) {
        if(color != sender.color){
            resetColorButton(button: color)
            color = sender.color;
            sender.alpha = 0.25;
        }
        else{
            sender.alpha = 1;
            color = Color.null;
        }
    }
    
    func resetColorButton(button: Color){
        switch(button){
        case .r:
            red.alpha = 1;
            break;
        case .b:
            blue.alpha = 1;
            break;
        case .g:
            green.alpha = 1;
            break;
        case .p:
            purple.alpha = 1;
            break;
        default:
            orange.alpha = 1;
            break;
        }
    }
    func getColor(cName: Color) -> UIColor{
        let c: UIColor;
        switch cName {
        case .r:
            c = UIColor.red;
            break;
        case .b:
            c = UIColor.blue;
            break;
        case .g:
            c = UIColor.green;
            break;
        case .p:
            c = UIColor.purple;
            break;
        default:
            c = UIColor.orange;
            break;
        }
        return c;
    }
    
    @IBAction func switchShapeFill(_ sender: UISwitch) {
        if sender.isOn == true {
            fillSwitchLabel.text! = (ShapeFill.sol).rawValue;
            shapeFill = .sol;
        }
        else {
            fillSwitchLabel.text! = (ShapeFill.out).rawValue;
            shapeFill = .out;
        }
    }
}

// TODO Cite this
// https://stackoverflow.com/questions/30696307/how-to-convert-a-uiview-to-an-image

extension UIView {
    func convertToImage() -> UIImage {
        let imageRenderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return imageRenderer.image { context in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
    func makeBackgroundImage(image: UIImage?){
        guard image != nil, let oldImage = image else {
            backgroundColor = UIColor.darkGray;
            return
        }
        let imageToViewScale = max(oldImage.size.width/bounds.width, oldImage.size.height/bounds.height)
        let newImage = UIImage(cgImage: oldImage.cgImage!, scale: imageToViewScale, orientation: oldImage.imageOrientation)
        self.backgroundColor = UIColor(patternImage: newImage)
    }
}
