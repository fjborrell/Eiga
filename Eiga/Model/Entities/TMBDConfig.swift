//
//  TMBDConfig.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation

/// Configures and manages image URLs for The Movie Database (TMDB) API.
struct TMBDImageConfig: Hashable {
    // MARK: - Constants
    
    /// The base URL for non-secure image requests.
    let baseURL: URL = URL(string: "http://image.tmdb.org/t/p/")!
    
    /// The base URL for secure image requests.
    let secureBaseURL: URL = URL(string: "https://image.tmdb.org/t/p/")!
    
    // MARK: - Image Sizes
    
    /// Available sizes for backdrop images.
    let backdropSizes: [BackdropSize] = BackdropSize.allCases
    
    /// Available sizes for logo images.
    let logoSizes: [LogoSize] = LogoSize.allCases
    
    /// Available sizes for poster images.
    let posterSizes: [PosterSize] = PosterSize.allCases
    
    /// Available sizes for profile images.
    let profileSizes: [ProfileSize] = ProfileSize.allCases
    
    /// Available sizes for still images.
    let stillSizes: [StillSize] = StillSize.allCases
    
    // MARK: - Protocols
    
    /// Defines the requirements for an image size.
    protocol ImageSize {
        var rawValue: String { get }
    }
    
    // MARK: - Methods
    
    /// Constructs a complete URL for an image.
    /// - Parameters:
    ///   - path: The specific path for the image.
    ///   - size: The desired size of the image.
    /// - Returns: A complete URL for the requested image.
    func buildURL(path: String, size: ImageSize) -> URL {
        return secureBaseURL.appending(path: size.rawValue).appending(path: path)
    }
    
    // MARK: - Image Size Enums
    
    /// Represents available sizes for backdrop images.
    enum BackdropSize: String, CaseIterable, ImageSize {
        case w300, w780, w1280, original
    }
    
    /// Represents available sizes for logo images.
    enum LogoSize: String, CaseIterable, ImageSize {
        case w45, w92, w154, w185, w300, w500, original
    }
    
    /// Represents available sizes for poster images.
    enum PosterSize: String, CaseIterable, ImageSize {
        case w92, w154, w185, w342, w500, w780, original
    }
    
    /// Represents available sizes for profile images.
    enum ProfileSize: String, CaseIterable, ImageSize {
        case w45, w185, h632, original
    }
    
    /// Represents available sizes for still images.
    enum StillSize: String, CaseIterable, ImageSize {
        case w92, w185, w300, original
    }
}

/// Represents errors that can occur when handling images.
enum ImageError: Error {
    /// Indicates that the image path is missing.
    case missingImagePath
    
    /// Indicates that the constructed URL is invalid.
    case invalidURL
}
