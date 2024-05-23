//
//  VoxelVC.swift
//  VoxelUI
//
//  Created by Jonathan French on 21.05.24.
//

import UIKit
import VoxelUIData

class VoxelVC: UIViewController {
    
    let depth = 16
    var width = 60
    var constraintArray = [[NSLayoutConstraint]]()
    var columnArray = [[UIView]]()
    var depthArray = [UIView]()
    var rate = 0
//    var controls = Controls()
    
    let alphaDepth:[CGFloat] = [1.0,0.95,0.90,0.85,0.80,0.75,0.70,0.65,0.60,0.56,0.54,0.52,0.50,0.48,0.46,0.44,0.42,0.40,0.38,0.36]
    let heightDepth:[CGFloat] = [0.5,1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0,3.2,3.4,3.6,3.8,4.0]
    
        var xPos = 256.0
        var yPos = 0.0
        let speed = 4
        var angle = 0.0  {
            didSet {
                angleLable.text = "Angle: \(Int(angle))°"
            }
        }
        let height = 0

    // Main window that is constrained to the layout margins
    lazy private var mainWindow: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = UIColor(rgb: 0x87ceeb) // Nice sky Blue
        vw.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapAction (_:)))
        vw.addGestureRecognizer(gesture)
        return vw
    }()
    
    //ViewPort sits on top of the mainwindow and is slightly bigger to allow for some movement
    lazy private var viewPort: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .clear
        vw.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.tapAction (_:)))
        vw.addGestureRecognizer(gesture)
        return vw
    }()
    
    //Angle lable
    lazy private var angleLable: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = .clear
        lb.text = "Angle 0°"
        lb.font = .boldSystemFont(ofSize: 18.0)
        lb.textAlignment = .right
        lb.textColor = .darkGray
        return lb
    }()
    
    func setupMainWindowConstraints() {
        let margins = view.layoutMarginsGuide
        let mainWindowConstraints = [
            self.mainWindow.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.mainWindow.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.mainWindow.topAnchor.constraint(equalTo: margins.topAnchor),
            self.mainWindow.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ]
        NSLayoutConstraint.activate(mainWindowConstraints)
    }
    
    func setupViewPortConstraints() {
        let viewPortConstraints = [
            self.viewPort.centerXAnchor.constraint(equalTo: mainWindow.centerXAnchor),
            self.viewPort.centerYAnchor.constraint(equalTo: mainWindow.centerYAnchor),
            self.viewPort.heightAnchor.constraint(equalTo: mainWindow.heightAnchor, multiplier: 1, constant: 120),
            self.viewPort.widthAnchor.constraint(equalTo: mainWindow.widthAnchor, multiplier: 1, constant: 80)
        ]
        NSLayoutConstraint.activate(viewPortConstraints)
    }
    
    func setupAngleLableConstraints() {
        let angleLableConstraints = [
            self.angleLable.trailingAnchor.constraint(equalTo: mainWindow.trailingAnchor, constant: -20),
            self.angleLable.topAnchor.constraint(equalTo: mainWindow.topAnchor, constant: 10),
            self.angleLable.heightAnchor.constraint(equalToConstant: 30),
            self.angleLable.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(angleLableConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.mainWindow)
        setupMainWindowConstraints()
        self.mainWindow.addSubview(self.viewPort)
        setupViewPortConstraints()
        self.mainWindow.addSubview(self.angleLable)
        setupAngleLableConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDepth()
        setupDepthColumns()
        setUpColumns()
        self.mainWindow.bringSubviewToFront(self.angleLable)
        moveData()
        //Oooh a displayLink yay!
        let displayLink:CADisplayLink = CADisplayLink(target: self, selector: #selector(refreshDisplay))
        displayLink.add(to: .main, forMode:.common)
    }
    //tap screen left side or right to change the angle
    @objc func tapAction(_ sender:UITapGestureRecognizer){
        let point = sender.location(in: self.view)
        if point.x > 400 {
            angle += 10.0
            if angle > 359 {
                angle = 0
            }
            let plusRadian : CGFloat = 10 * CGFloat((Double.pi/180))
            UIView.animate(withDuration:0.25) {
                self.viewPort.transform = CGAffineTransform(rotationAngle: plusRadian)
            } completion: { _ in
                UIView.animate(withDuration:0.25) {
                    self.viewPort.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
        } else {
            angle -= 10.0
            if angle < 0 {
                angle = 350
            }
            let minusRadian : CGFloat = 350 * CGFloat((Double.pi/180))
            UIView.animate(withDuration:0.25) {
                self.viewPort.transform = CGAffineTransform(rotationAngle: minusRadian)
            } completion: { _ in
                UIView.animate(withDuration:0.25) {
                    self.viewPort.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
            UIView.animate(withDuration:0.5, animations: {
                self.viewPort.transform = CGAffineTransform(rotationAngle: minusRadian)
            })
        }
        print("Tappppp \(angle)   x\(xPos) y \(yPos)")
    }
    
    func moveData() {
        if let heightData = getPointsWithAngle(data: VoxelUIData.voxelHeight.heightData, angle: angle, initialStartX: xPos, initialStartY: yPos, moveDistance: 1) {
            for (rowIndex,row) in heightData.enumerated() {
                for (colIndex,height) in row.enumerated() {
                    constraintArray[rowIndex][colIndex].constant = CGFloat(height) * heightDepth[rowIndex] + 60
                }
            }
        } else {
            print("Error: Out of bounds.")
            print("positions x \(xPos) y \(yPos)")
            angle = 180 - angle
            if yPos >= 512 { yPos = 511}
            if yPos < 0 { yPos = 0}
            if xPos >= 512 { xPos = 511}
            if xPos < 0 { xPos = 0}

            return
        }
        
        if let colorData = getPointsWithAngle(data: VoxelUIData.voxelColor.colorData, angle: angle, initialStartX: xPos, initialStartY: yPos, moveDistance: 1) {
            for (rowIndex,row) in colorData.enumerated() {
                for (colIndex,color) in row.enumerated() {
                    columnArray[rowIndex][colIndex].backgroundColor = getColor(index:color ).withAlphaComponent(alphaDepth[rowIndex])
                }
            }
        } else {
            print("Error: Out of bounds.")
            return
        }
        
        // Update the position
        let radians = angle * .pi / 180.0
        xPos += 1 * cos(radians + .pi / 2)
        yPos += 1 * sin(radians + .pi / 2)
        //print("New positions x \(controls.xPos) y \(controls.yPos)")
    }
    
    func setupDepth() {
        for _ in 0...depth - 1 {
            let view = UIView()
            view.backgroundColor = .clear
            view.frame = viewPort.frame
            view.frame.origin = CGPoint(x: 0, y: 0)
            depthArray.append(view)
        }
    }
    
    func setUpColumns() {
        let viewWidth = Double(viewPort.frame.width / CGFloat(width))
        for d in 0...depth-1 {
            var lineArray = [UIView]()
            var lineConstraint = [NSLayoutConstraint]()
            for i in 0...width-1 {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: depthArray[d], attribute: .bottom, multiplier: 1, constant: 0)
                let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewWidth)
                let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
                let leftAttr = (i == 0 ? depthArray[d] : lineArray[i - 1])
                let leftConstraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: leftAttr, attribute: i == 0 ? .left : .right, multiplier: 1, constant: 0)
                lineArray.append(view)
                lineConstraint.append(heightConstraint)
                depthArray[d].addSubview(view)
                depthArray[d].addConstraints([bottomConstraint,widthConstraint,heightConstraint,leftConstraint])
            }
            columnArray.append(lineArray)
            constraintArray.append(lineConstraint)
        }
    }
    
    func setupDepthColumns(){
        for v in depthArray.reversed() {
            viewPort.addSubview(v)
        }
    }
    
    @objc func refreshDisplay() {
        rate+=1
        if rate == speed {
            moveData()
            rate = 0
        }
    }

    func getPointsWithAngle(data: [[Int]], angle: Double, initialStartX: Double, initialStartY: Double, moveDistance: Double) -> [[Int]]? {
        let numRows = data.count
        guard numRows > 0 else { return nil }
        let numCols = data[0].count
        guard numCols > 0 else { return nil }
        guard initialStartX >= 0 && Int(initialStartX) < numCols && initialStartY >= 0 && Int(initialStartY) < numRows else { return nil }
        
        // Convert angle from degrees to radians
        let radians = angle * .pi / 180.0
        
        // Define the 2D array to store the results
        var result: [[Int]] = Array(repeating: Array(repeating: 0, count: width), count: depth)
        
        for i in 0..<depth {
            for j in 0..<width {
                
                let distanceX = Double(j)
                let distanceY = Double(i)
                let x = Double(initialStartX) + distanceX * cos(radians) - distanceY * sin(radians)
                let y = Double(initialStartY) + distanceX * sin(radians) + distanceY * cos(radians)
                
                // Round to nearest integer and check boundaries
                let intX = Int(round(x))
                let intY = Int(round(y))
                
                if intX >= 0 && intX < numCols && intY >= 0 && intY < numRows {
                    result[i][j] = data[intY][intX]
                } else {
                    // Append a default value if out of bounds
                    result[i][j] = 0
                }
            }
        }
        return result
    }
}
