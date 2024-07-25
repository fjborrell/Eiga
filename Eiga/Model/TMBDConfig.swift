//
//  TMBDConfig.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

struct TMBDImageConfig: Hashable {
    let baseURL: URL = URL(string: "http://image.tmdb.org/t/p/")!
    let secureBaseURL: URL = URL(string: "https://image.tmdb.org/t/p/")!
    let backdropSizes: [BackdropSize] = BackdropSize.allCases
    let logoSizes: [LogoSize] = LogoSize.allCases
    let posterSizes: [PosterSize] = PosterSize.allCases
    let profileSizes: [ProfileSize] = ProfileSize.allCases
    let stillSizes: [StillSize] = StillSize.allCases
    
    protocol ImageSize {
        var rawValue: String { get }
    }
    
    func buildURL(path: String, size: ImageSize) -> URL {
        return secureBaseURL.appending(path: size.rawValue).appending(path: path)
    }
    
    enum BackdropSize: String, CaseIterable, ImageSize {
        case w300, w780, w1280, original
    }
    
    enum LogoSize: String, CaseIterable, ImageSize {
        case w45, w92, w154, w185, w300, w500, original
    }
    
    enum PosterSize: String, CaseIterable, ImageSize {
        case w92, w154, w185, w342, w500, w780, original
    }
    
    enum ProfileSize: String, CaseIterable, ImageSize {
        case w45, w185, h632, original
    }
    
    enum StillSize: String, CaseIterable, ImageSize{
        case w92, w185, w300, original
    }
}

enum ImageError: Error {
    case missingImagePath
    case invalidURL
}
