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
    let id: VideoId
    var title: String {
        return snippet.title.decodeHTML()
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
struct VideoId: Codable{
    
    let videoId:String
    
}



// data decode etme
extension String {
    func decodeHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }
        return attributedString.string
    }
}


