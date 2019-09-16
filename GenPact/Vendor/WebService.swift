//
//  WebService.swift
//  GenPact
//
//  Created by ketan shinde on 15/09/19.
//  Copyright © 2019 ketan shinde. All rights reserved.
//

import Foundation

struct GeneralError: Error {
    let message: String
}

struct ApiSession {
    
    var urlString: String?

    init(){}
    
    private func parse <T:Codable> (responseData: Data, type: T.Type) -> T? {
        do {            
            let responseStrInISOLatin = String(data: responseData, encoding: .isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: .utf8) else {
                print("could not convert data to UTF-8 format")
                return nil
            }
            let json = try JSONDecoder().decode(type, from: modifiedDataInUTF8Format)
            return json
        }
        catch let error {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    func fetchData <T: Codable> (type: T.Type, completion: @escaping (T?, Error?) -> ()) {
        
        if  Reachability()!.connection == .none {
            return completion(nil, GeneralError(message: "No Internet Connection!"))
        }
        
        guard let url = URL(string: urlString!) else { return }
        
        var request = URLRequest(url: url, cachePolicy:NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, resp, err) in
            
            if let err = err {
                return completion(nil, err)
            }
            guard let data = data else {
                return  completion(nil, GeneralError(message: "No Data Found!"))
            }
            
            guard let result = self.parse(responseData: data, type: type) else {
                return completion(nil, GeneralError(message: "Couldn't Decode!"))
            }

            completion(result, nil)
            
        }.resume()
    }
}

