//
//  OverOnsViewController.swift
//  KljApp
//
//  Created by Bruno Stroobants on 06/12/2018.
//  Copyright © 2018 Bruno Stroobants. All rights reserved.
//

import UIKit

class OverOnsViewController: UIViewController {

    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    @IBOutlet weak var pic3: UIImageView!
    @IBOutlet weak var pic4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pic1.layer.cornerRadius = 15
        pic1.clipsToBounds = true
        
        pic2.layer.cornerRadius = 15
        pic2.clipsToBounds = true
        
        pic3.layer.cornerRadius = 15
        pic3.clipsToBounds = true
        
        pic4.layer.cornerRadius = 15
        pic4.clipsToBounds = true

    }
    

}
