//
//  NetworkHandler.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

class NetworkClient {
    
    // let session = URLSession()
    
    // Getting data
    // Completion Handler setup: https://stackoverflow.com/a/43048512
    
    func fetch(url: URL, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        
        /* guard let _ = url.absoluteString.count > 0 else {
            return
        }*/
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard let _ = data, error == nil else {
                print("Something  went wrong: \(error?.localizedDescription ?? "")")
                completionHandler(data, response, error as NSError?)
                
                return
                
            }
            
            completionHandler(data, response, error as NSError?)
                        
        }
        
        task.resume()
        
        
    }
}
