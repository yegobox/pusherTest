//
//  ViewController.swift
//  pusher
//
//  Created by richard on 8/21/19.
//  Copyright © 2019 richard. All rights reserved.
//

import UIKit
import PusherSwift


class AuthRequestBuilder: AuthRequestBuilderProtocol {
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: "https://yegobox.com/broadcast/auth")!)
        request.httpMethod = "POST"
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        request.addValue("Bearer {token}", forHTTPHeaderField: "Authorization")
        return request
    }
}


class ViewController: UIViewController {
    
    var pusher = Pusher(
        key: "YourKEy",
        options: PusherClientOptions(
             authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
             host: .cluster("us2")
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let channel = pusher.subscribe("private-purchases.{MurugoUserId}")
        
        let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
        })
        
        pusher.connect()
        
        print("we got here")
    }

    @IBAction func showMe(_ sender: Any) {
        print("Hello we are listening")
        pusher.connect();
    }
    
}

