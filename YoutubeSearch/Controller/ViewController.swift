//
//  ViewController.swift
//  YoutubeSearch
//
//  Created by özge kurnaz on 19.05.2024.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,YoutubeSearchDelegate{
    @IBOutlet weak var videoPlayerView: WKWebView!
    
    
    
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var youtubeSearchManager = YoutubeSearchManager()
    var youtubeSearchData: [YouTubeSearchData] = []
    var videoUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.textAlignment = .left
        searchBar.delegate = self
        youtubeSearchManager.delegate = self
        tableView.delegate=self
        tableView.dataSource=self
        tableView.alwaysBounceVertical = true // kaydırılabilir
        
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoPlayerView)

        
    }
    
    @IBAction func searchButtonClicked(_ sender:UIButton) {
        let searchedText = searchBar.text!
        youtubeSearchManager.fetchData(query: searchedText)
        searchBar.text=""
        print(youtubeSearchManager.fetchData(query: searchedText))
    }
    
    func didUpdateSearchResults(_ results: [YouTubeSearchData]) {
        DispatchQueue.main.async {
            self.youtubeSearchData = results
            self.tableView.reloadData()
        }
    }
    
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeSearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        let result = youtubeSearchData[indexPath.row]
        cell.textLabel?.text = result.title
        cell.textLabel?.numberOfLines = 0 // Allow multiple lines
        if let thumbnailURL = result.thumbnailURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: thumbnailURL) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = youtubeSearchData[indexPath.row]
        
        let videoId = selectedVideo.id.videoId
        videoUrl = "https://www.youtube.com/embed/\(videoId)"
        watchVideo(videoUrl: videoUrl)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80 // Hücre yüksekliği
     }

     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let footerView = UIView()
         footerView.backgroundColor = .clear
         return footerView
     }

 
    func watchVideo(videoUrl:String){
        guard let url = URL(string: videoUrl) else {return}
        let req = URLRequest(url:url)
        videoPlayerView.load(req)
    }
}
