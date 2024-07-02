//
//  NetworkError.swift
//  Eiga
//
//  Created by Fernando Borrell on 6/28/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(error: String)
    case HTTPError(error: String)
    case unexpectedHTTPResponse(error: String)
    case unexpectedData(error: String)
    case failedJSONDecoding(error: Error)
    case APIRequestError(nestedError: Error)
}
