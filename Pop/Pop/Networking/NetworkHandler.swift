//
//  NetworkHandler.swift
//  Pop
//
//  Created by Markus Jahnsrud on 30/10/2019.
//  Copyright © 2019 Markus Jahnsrud. All rights reserved.
//

import Foundation

class NetworkHandler {
    
    // let session = URLSession()
    
    // Getting data
    // Completion Handler setup: https://stackoverflow.com/a/43048512
    
    func getData(url: URL, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
