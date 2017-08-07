//
//  CreateUsernameViewController.swift
//  CardCartOfficial
//
//  Created by Jay Patel on 8/1/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit

class FinishSignUpViewController: UIViewController {
    
    var user: User!
    
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        User.setCurrent(self.user, writeToUserDefaults: true)
        // Create user object set to current user and write to defaults
        let initialViewController = UIStoryboard.initialViewController(for: .main)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


