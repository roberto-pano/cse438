//
//  ColorButton.swift
//  RobertoPanora-Lab3
//
//  Created by Roberto Panora on 10/4/23.
//

import Foundation
import UIKit

class ColorButton: UIButton {
    var color: Color = Color.null;
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width;
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
        self.setTitle("", for: .normal);
    }
    func setup(c: UIColor, colorName: Color){
        self.backgroundColor = c;
        self.color = colorName;
    }
}


