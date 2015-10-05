//
//  ViewController.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/1/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit



class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTwitterLogin(sender: AnyObject) {
        TwitterClient.instance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
