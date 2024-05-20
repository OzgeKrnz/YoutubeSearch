//
//  YoutubeSearchData.swift
//  YoutubeSearch
//
//  Created by özge kurnaz on 20.05.2024.
//

import Foundation

struct YouTubeResponse: Codable {
    let items: [YouTubeSearchData]
}

struct YouTubeSearchData: Codable {
    let snippet: VideoSnippet
    
    var title: String {
        return snippet.title
    }
    
    var thumbnailURL: URL? {
        return URL(string: snippet.thumbnails.medium.url)
    }
}

struct VideoSnippet: Codable {
    let title: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
    let medium: ThumbnailDetails
}

struct ThumbnailDetails: Codable {
    let url: String
}

