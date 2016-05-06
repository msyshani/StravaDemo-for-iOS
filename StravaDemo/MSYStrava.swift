//
//  MSYStrava.swift
//  StravaDemo
//
//  Created by Mahendra Yadav on 4/29/16.
//  Copyright © 2016 App Engineer. All rights reserved.
//

import UIKit


let stravaClientId=""
let stavaClientSecret=""
let stavaAuthoriseUrl="https://www.strava.com/oauth/authorize"
let stavaAccessToken="https://www.strava.com/oauth/token"
let stavaDeauthoriseUrl="https://www.strava.com/oauth/deauthorize"


class MSYStrava: NSObject {
    
    
    
    // completion handler
    typealias stravaBlockType = (result:Dictionary<String , AnyObject>,success:Bool) ->Void
    var completionStrava:stravaBlockType?
    
    class var shareInstance:MSYStrava{
        struct Static {
            static var onceToken:dispatch_once_t=0
            static var instance:MSYStrava?=nil
        }
        
        dispatch_once(&Static.onceToken){
            Static.instance=MSYStrava()
        }
        
        return Static.instance!
    }
    
    
    let oauthswift = OAuth2Swift(
        consumerKey:    stravaClientId, //serviceParameters["consumerKey"]!,
        consumerSecret: stavaClientSecret,
        authorizeUrl:   stavaAuthoriseUrl,
        accessTokenUrl: stavaAccessToken,
        responseType:   "code"
    )
    
    
    func loginWithStava(completion: (result: Dictionary<String , AnyObject>, success:Bool) -> Void){
        
        completionStrava = completion
        
        
        
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "StravaHelper://localhost")!, scope: "view_private", state: state, success: {
            credential, response, parameters in
            
            print("access token is \(parameters)")
            
            print("access token is \(parameters["access_token"])")
        NSUserDefaults.standardUserDefaults().setValue(parameters["access_token"], forKey: "Stoken")
           
            self.getDataFromStava(self.oauthswift)
            
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    
    
    
    //MARK: GET DATA form strava
    func getDataFromStava(oauthswift: OAuth2Swift) {
        
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Stoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://www.strava.com/api/v3/activities/13233267", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            print(jsonDict)
            
            self.completionStrava!(result:jsonDict as! Dictionary<String, AnyObject>,success:true)
            
            }) { (error) -> Void in
                print(error.localizedDescription)
                let dataDic=[String: AnyObject]()
                 self.completionStrava!(result: dataDic, success: false)
                
                //self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    

}
