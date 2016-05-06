//
//  ViewController.swift
//  StravaDemo
//
//  Created by Mahendra Yadav on 4/29/16.
//  Copyright © 2016 App Engineer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginStrava(sender:AnyObject){
        MSYStrava.shareInstance.loginWithStava { (result, success) -> Void in
            
            if success{
                print(result)
            }else{
                print("error...")
            }
        }
    }


}

