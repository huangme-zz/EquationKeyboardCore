//
//  DatabaseConnector.swift
//  Equation_Keyboard
//
//  Created by Yiyi Wang on 10/8/16.
//  Copyright © 2016 Yiyi Wang. All rights reserved.
//

import Foundation
import UIKit

class DatabaseConnector {
    static var offlineMode = false
    
    // remember update info.plist after changing AWS_adddress
    static var AWS_address : String = "http://ec2-54-146-55-27.compute-1.amazonaws.com:8080/"
    static var AWS_root: String = "http://ec2-54-146-55-27.compute-1.amazonaws.com"
    static var AWS_py_port: String = ":3001"
    static var AWS_render_tail: String = "/secret/equation_keyboard/api/v1/render"
    static var AWS_render_large_tail: String = "/secret/equation_keyboard/api/v1/render_big"
    static var AWS_static_tail: String = "/secret/equation_keyboard/static/"
    static var re_cache = [String:String]()
    static var re_cache_large = [String:String]()
    
    private func elasticsearch_search(keyword: String) -> String! {
        var result: String! = nil
        
        var url_to_request:String
        if keyword != "" {
            let escapedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            url_to_request = DatabaseConnector.AWS_address + "/_search/?size=1000&q=tag:" + escapedKeyword!
        } else {
            url_to_request = DatabaseConnector.AWS_address + "/_search/?size=1000"
        }
        
        // prepare url request
        let semaphore = DispatchSemaphore(value: 0)
        let url:NSURL = NSURL(string: url_to_request)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        // start HTTP request
        let task = session.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            guard let _:NSData = data as NSData?, let _:URLResponse = response , error == nil else {
                    result = nil
                    semaphore.signal()
                    return
            }
            
            result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        return result
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func perform_search(keyword: String) -> [String]! {
        if DatabaseConnector.offlineMode {
            return ["$+$+$"]
        }
        
        var result: [String]! = []
        
        // get elasticsearch result
        guard let query_result = elasticsearch_search(keyword: keyword) else {
            return []
        }
        
        // get terms containing $ and enclosed by quote marks
        result = matches(for: "\"(.*?)\"", in: query_result).filter { (element) -> Bool in
            if element.contains("$") {
                return true
            }
            return false
        }
        
        // remove quote marks
        result = result.flatMap({ (element) -> String? in
            element.replacingOccurrences(of: "\"", with: "")
        })
        
        result = result.flatMap({ (element) -> String? in
            element.replacingOccurrences(of: "\\\\", with: "\\")
        })
        
        print("this is from els :" + String(describing: result))
        return result
    }
    
    func getLatexRenderedURL(latexExp : String) -> String?{
        if let cached_address = DatabaseConnector.re_cache[latexExp] {
            // now val is not nil and the Optional has been unwrapped, so use it
            return cached_address
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var post_success = false
        let url_to_request = DatabaseConnector.AWS_root + DatabaseConnector.AWS_py_port + DatabaseConnector.AWS_render_tail
        let url:NSURL = NSURL(string: url_to_request)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        var postString = "src=" + latexExp//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        postString = postString.replacingOccurrences(of: "+", with: "%2B", options: .literal, range: nil)
        print(postString + "\n")
        request.httpBody = postString.data(using: .utf8)
        
        var file_name = "nil"
        
        // start HTTP request
        let task = session.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            guard let _:NSData = data as NSData?, let _:URLResponse = response , error == nil else {
                post_success = false
                semaphore.signal()
                return
            }
            post_success = true
            file_name = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "nil"
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        if (post_success) {
            DatabaseConnector.re_cache[latexExp] = file_name
            return file_name
        } else {
            return nil
        }

    }
    
    func getLatexRenderedURL_large(latexExp : String) -> String?{
        
        if let cached_address = DatabaseConnector.re_cache_large[latexExp] {
            // now val is not nil and the Optional has been unwrapped, so use it
            return cached_address
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var post_success = false
        let url_to_request = DatabaseConnector.AWS_root + DatabaseConnector.AWS_py_port + DatabaseConnector.AWS_render_large_tail
        let url:NSURL = NSURL(string: url_to_request)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        var postString = "src=" + latexExp//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        postString = postString.replacingOccurrences(of: "+", with: "%2B", options: .literal, range: nil)
        print(postString + "\n")
        request.httpBody = postString.data(using: .utf8)
        
        var file_name = "nil"
        
        // start HTTP request
        let task = session.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            guard let _:NSData = data as NSData?, let _:URLResponse = response , error == nil else {
                post_success = false
                semaphore.signal()
                return
            }
            post_success = true
            file_name = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "nil"
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        if (post_success) {
            DatabaseConnector.re_cache_large[latexExp] = file_name
            return file_name
        } else {
            return nil
        }
    }

}
