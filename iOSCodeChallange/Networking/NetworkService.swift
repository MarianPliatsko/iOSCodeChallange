//
//  NetworkingService.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-27.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error{
    case urlIsMissing
    case notFound
    case badResponse
    case unknown
}

class StubNetworkService {
    
    private let baseURL = URL(string: "https://some.my.url.com/")!
    
    func request(urlRequest: URLRequest, complition: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                complition(.failure(NetworkError.unknown))
                return
            }
            guard let url = urlRequest.url else {
                complition(.failure(NetworkError.urlIsMissing))
                return
            }
            if url.absoluteString.hasSuffix("api/login") {
                if let data = self.loginMineResponse().data(using: .utf8) {
                    complition(.success(data))
                    return
                } else {
                    complition(.failure(NetworkError.badResponse))
                    return
                }
            }
            if url.absoluteString.hasSuffix("api/schedule") {
                if let data = self.sheduleMineResponse().data(using: .utf8) {
                    complition(.success(data))
                    return
                } else {
                    complition(.failure(NetworkError.badResponse))
                    return
                }
            }
            complition(.failure(NetworkError.notFound))
        }
        
    }
    
    func makeRequest(for endpoint: String,baseURL: URL, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Fake token", forHTTPHeaderField: "Bearer")
        return request
    }
    
    func makeLogIn(complition: @escaping(Result<UserResponse, Error>) -> Void) {
        let request = makeRequest(for: "api/login",
                                  baseURL: self.baseURL,
                                  method: .post)
        self.request(urlRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    complition (.success(try JSONDecoder().decode(UserResponse.self, from: data)))
                }
                catch {
                    complition (.failure(error))
                }
            case .failure(let error):
                complition (.failure(error))
            }
        }
    }
    
    func getEvents(complition: @escaping(Result<Shedule,Error>) -> Void) {
        let request = makeRequest(for: "api/schedule",
                                  baseURL: self.baseURL,
                                  method: .get)
        self.request(urlRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    complition (.success(try JSONDecoder().decode(Shedule.self, from: data)))
                }
                catch {
                    complition (.failure(error))
                }
            case .failure(let error):
                complition (.failure(error))
            }
        }
    }
    
    private func loginMineResponse() -> String {
        return """
{
    "error":{
        "code":"int",
        "message":"string"
    },
    "data":{
        "access_token":"string",
        "refresh_token":"string"
    }
}
"""
    }
    
    private func sheduleMineResponse() -> String {
        return """
{
    "error":{
        "code":"int",
        "message":"string"},
    "data":[
        {
            "course_name":"string",
            "room":"string",
            "start_time":"datetime",
            "emd_time":"datetime"
        }
    ]
}
"""
    }
}

