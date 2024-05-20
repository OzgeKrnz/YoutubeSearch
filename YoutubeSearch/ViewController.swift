//
//  ViewController.swift
//  YoutubeSearch
//
//  Created by özge kurnaz on 19.05.2024.
//

import UIKit
import WebKit


class ViewController: UIViewController, UITextFieldDelegate, YoutubeSearchDelegate{
    

    
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    var youtubeSearchManager = YoutubeSearchManager()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.textAlignment = .left
        searchBar.delegate = self
        youtubeSearchManager.delegate = self

    }
    
    
    
    
    @IBAction func searchButtonClicked(_ sender:UIButton) {
        let searchedText = searchBar.text!
        youtubeSearchManager.fetchData(query: searchedText)
        

    }
    
    func didUpdateSearchResults(_ results: [YouTubeSearchData]) {
        for result in results {
            print(result.title)
        }
           
    }
    
    
    func didFailWithError(error: any Error) {
        print(error)
    }

    
    
    

}
