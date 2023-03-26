//
//  ViewController.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 15
            loginButton.layer.masksToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

