//
//  OutlineShape.swift
//  RobertoPanora-Lab3
//
//  Created by Roberto Panora on 10/6/23.
//

import Foundation
import UIKit

class OutlineShape: Shape {
    override func draw() {
        color.setStroke()
        shapePath.stroke(with: CGBlendMode.normal, alpha: transparency)
    }
}


class OutlineCircle: OutlineShape {
    var radius = CGFloat();
    required init(origin: CGPoint, color: UIColor) {
        self.radius = 30;
        super.init(origin: origin, color: color)
        shapePath.addArc(withCenter: origin, radius: 30, startAngle: 0, endAngle: CGFloat(Float.pi) * 2, clockwise: true);
    }
}

class OutlineRectangle: OutlineShape {
    var width: CGFloat;
    var height: CGFloat;
    
    required init(origin: CGPoint, color: UIColor) {
        self.width = 60;
        self.height = 30;
        super.init(origin: origin, color: color)
        let rectFrame = CGRect(x: origin.x-(width/2), y: origin.y-(height/2), width: width, height: height);
        shapePath = UIBezierPath(rect: rectFrame);
    }
}

class OutlineTriangle: OutlineShape {
    
    required init(origin: CGPoint, color: UIColor) {
        super.init(origin: origin, color: color);
        shapePath = UIBezierPath();
        shapePath.move(to: CGPoint(x: origin.x, y: origin.y + 20));
        shapePath.addLine(to: CGPoint(x: origin.x + 20, y: origin.y - 20));
        shapePath.addLine(to: CGPoint(x: origin.x - 20, y: origin.y - 20));
        shapePath.close();
    }
}

