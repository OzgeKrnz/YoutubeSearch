//
//  YoutubeSearchManager.swift
//  YoutubeSearch
//
//  Created by özge kurnaz on 20.05.2024.
//

import Foundation

protocol YoutubeSearchDelegate{
    func didFailWithError(error:Error)
    func didUpdateSearchResults(_ results: [YouTubeSearchData])
}

struct YoutubeSearchManager{
    let dataUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet"
    
    var delegate: YoutubeSearchDelegate?
    
    func fetchData(query:String){
        let apiKey = "AIzaSyAR3NgF2ZMbHWTAIXPpVGvx76oDgPDQcGI"
        let urlString = "\(dataUrl)&q=\(query)&type=video&key=\(apiKey)"
        performRequest(urlString: urlString)
        print(urlString)
        
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    self.delegate?.didFailWithError(error: err)
                    return
                }
                if let safeData = data {
                    if let searchResults = self.parseJSON(safeData) {
                        self.delegate?.didUpdateSearchResults(searchResults)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ searchData: Data) -> [YouTubeSearchData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(YouTubeResponse.self, from: searchData)
            let searchResults = decodedData.items
            return searchResults
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
