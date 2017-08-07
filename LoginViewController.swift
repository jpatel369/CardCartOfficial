//
//  LoginViewController.swift
//  CardCart
//
//  Created by Jay Patel on 7/10/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login Button Tapped")
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self //as ? FUIAuthDelegate is a maybe just added because error
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == Constants.Segue.toFinishSignIn {
            let nextVC = segue.destination as! FinishSignUpViewController
            nextVC.user = self.user
        }
     }
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            // assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        self.user = User.init(uid: user!.uid)
        
        
        self.performSegue(withIdentifier: Constants.Segue.toFinishSignIn, sender: nil)
        
    }
}
