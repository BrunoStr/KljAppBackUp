//
//  ContactViewController.swift
//  KljApp
//
//  Created by Bruno Stroobants on 06/12/2018.
//  Copyright © 2018 Bruno Stroobants. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    
    @IBOutlet weak var fbLogo: UIImageView!
    @IBOutlet weak var instaLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 1.0, delay:0.0 ,options: [.curveEaseInOut], animations: {
            
            let translate = CGAffineTransform(translationX: 0, y: -10)
            
            self.fbLogo.transform = translate
            self.instaLogo.transform = translate
            
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, delay:0.0, options:[.curveEaseInOut], animations: {
                self.fbLogo.transform = CGAffineTransform.identity
                self.instaLogo.transform = CGAffineTransform.identity
                
            })
        }

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
