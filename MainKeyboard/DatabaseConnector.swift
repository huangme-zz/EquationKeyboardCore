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
    // You might need to update this address
    static var http_server_address : String = "localhost"
    static var elastic_search_port : String = "9200"
    static var python_flask_port: String = "3000"
    
    static var python_render_tail: String = "/secret/equation_keyboard/api/v1/render"
    static var python_render_big_tail: String = "/secret/equation_keyboard/api/v1/render_big"
    static var python_static_tail: String = "/secret/equation_keyboard/static"

    
    static var elastic_address : String = "http://" + http_server_address + ":" + elastic_search_port
    static var python_root_address : String = "http://" + http_server_address + ":" + python_flask_port

    
    static var re_cache = [String:String]()
    static var re_cache_large = [String:String]()
    
    private func elasticsearch_search(keyword: String) -> String! {
        var result: String! = nil
        
        var url_to_request:String
        if keyword != "" {
            let escapedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            url_to_request = DatabaseConnector.elastic_address + "/_search/?size=1000&q=tag:" + escapedKeyword!
        } else {
            url_to_request = DatabaseConnector.elastic_address + "/_search/?size=1000"
        }
        
        print(url_to_request)
        
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
    
    private func render_connector(target_address: String, latex_string: String) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var post_success = false
        let url:NSURL = NSURL(string: target_address)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        var postString = "src=" + latex_string
        postString = postString.replacingOccurrences(of: "+", with: "%2B", options: .literal, range: nil)
        print(postString + "\n")
        request.httpBody = postString.data(using: .utf8)
        
        var result = "nil"
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
            result = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? "nil"
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        if (post_success) {
            return result
        } else {
            return nil
        }
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
        
        print("this is from elastic search :" + String(describing: result))
        return result
    }
    
    func getLatexRenderedURL(latexExp : String) -> String?{
        // first try get it from local cache
        if let cached_address = DatabaseConnector.re_cache[latexExp] {
            return cached_address
        }
        
        let python_render_address : String = DatabaseConnector.python_root_address + DatabaseConnector.python_render_tail
        let result : String? = render_connector(target_address: python_render_address, latex_string: latexExp)
        
        if (result != nil) {
            DatabaseConnector.re_cache[latexExp] = result
            return result
        } else {
            return nil
        }
    }
    
    func getLatexRenderedURL_large(latexExp : String) -> String?{
        // first try get it from local cache
        if let cached_address = DatabaseConnector.re_cache_large[latexExp] {
            return cached_address
        }
        
        let python_render_big_address : String = DatabaseConnector.python_root_address + DatabaseConnector.python_render_big_tail
        let result : String? = render_connector(target_address: python_render_big_address, latex_string: latexExp)
        
        if (result != nil) {
            DatabaseConnector.re_cache[latexExp] = result
            return result
        } else {
            return nil
        }
    }

}
