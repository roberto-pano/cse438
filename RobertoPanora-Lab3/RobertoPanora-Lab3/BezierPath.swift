//
//  BezierPath.swift
//  RobertoPanora-Lab3
//
//  Created by Roberto Panora on 10/6/23.
//

import Foundation
import UIKit


// These methods were given on Piazza!!!


extension UIBezierPath {
    func rotate(by angleRadians: CGFloat){
        let center = CGPoint(x: bounds.midX, y: bounds.midY);
        var transform = CGAffineTransform.identity;
        transform = transform.translatedBy(x: center.x, y: center.y);
        transform = transform.rotated(by: angleRadians);
        transform = transform.translatedBy(x: -center.x, y: -center.y);
        self.apply(transform);
    }
}

extension UIBezierPath {
    func scaleAroundCenter(factor: CGFloat) {
        let beforeCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
    
        let scaleTransform = CGAffineTransform(scaleX: factor, y: factor);
        self.apply(scaleTransform);
    
        let afterCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY);
        let diff = CGPoint( x: beforeCenter.x - afterCenter.x, y: beforeCenter.y - afterCenter.y);
        
        let translateTransform = CGAffineTransform(translationX: diff.x, y: diff.y);
        self.apply(translateTransform);
    }
    
}

extension UIBezierPath {
    func movePath(oldOrigin: CGPoint, newOrigin: CGPoint) {
        let move = CGAffineTransform(translationX: newOrigin.x - oldOrigin.x, y: newOrigin.y - oldOrigin.y);
        self.apply(move);
    }
}
