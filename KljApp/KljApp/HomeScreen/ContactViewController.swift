//
//  ContactViewController.swift
//  KljApp
//
//  Created by Bruno Stroobants on 06/12/2018.
//  Copyright © 2018 Bruno Stroobants. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func fbBtnTapped(_ sender: Any) {
        let Username = "KLJvissenaken"
        let appURL = URL(string: "fb://profile/\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://www.facebook.com/\(Username)")!
            application.open(webURL)
        }
    }
    
    @IBAction func instagramBtnTapped(_ sender: Any) {
        let Username = "KLJ_vissenaken"
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }
    }
}
