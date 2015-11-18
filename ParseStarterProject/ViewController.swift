/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpActive = true
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var lblRegistered: UILabel!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @available(iOS 8.0, *)
    @IBAction func btnSignUp(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("SignUp Error", message: "Username or password missing")
        } else {
            showActivitySpinner()
            
            var errorMessage = "Please try again"
            
            if signUpActive == true {
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.hideActivitySpinner()
                    
                    if error == nil {
                        //signup successful
                        
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                            self.displayAlert("Registration Error", message: errorMessage)
                        }
                    }
                })
            } else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    self.hideActivitySpinner()
                    if user != nil {
                        
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Login Failed", message: errorMessage)
                    }
                })
            }
        }
    }
    @IBAction func btnLogin(sender: AnyObject) {
        if signUpActive == true {
            btnSignUp.setTitle("Log In", forState: UIControlState.Normal)
            lblRegistered.text = "Not Registered"
            btnLogin.setTitle("Sign Up", forState: UIControlState.Normal)
            signUpActive = false
        } else {
            btnSignUp.setTitle("Sign Up", forState: UIControlState.Normal)
            lblRegistered.text = "Already Registered?"
            btnLogin.setTitle("Log In", forState: UIControlState.Normal)
            signUpActive = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: Activity Spinner Code
    //show activity spinner
    func showActivitySpinner() {
        //add a spiny
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func hideActivitySpinner() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
