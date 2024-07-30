//
//  URL Session+data.swift
//  Image_Feed
//
//  Created by Evgenia Kucherenko on 07.07.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decoderError(Error)
}

extension URLSession {
    func objectTask<T:Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let fulfilCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                 completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let decodedModel = try jsonDecoder.decode(T.self, from: data)
                        fulfilCompletion(.success(decodedModel))
                    } catch {
                        print("Decoder error: \(error)")
                        fulfilCompletion(.failure(NetworkError.decoderError(error)))
                    }
                } else {
                    print("HTTP status code error: \(response.statusCode)")
                    fulfilCompletion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                }
            } else if let error {
                print("URL request error: \(error)")
                fulfilCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("URL session error")
                fulfilCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
