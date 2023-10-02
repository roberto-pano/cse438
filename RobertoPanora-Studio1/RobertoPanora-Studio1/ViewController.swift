//
//  ViewController.swift
//  RobertoPanora-Studio1
//
//  Created by Roberto Panora on 9/6/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var image: UIImageView!
    @IBAction func sliderMoved(_ sender: UISlider) {
        image.alpha = CGFloat(sender.value);
    }
}

