//
//  TrailerViewController.swift
//  PezFlix
//
//  Created by Julien Calfayan on 2/7/19.
//  Copyright © 2019 Julien Calfayan. All rights reserved.
//

import UIKit

class TrailerViewController: UIViewController {

    var movie: [String:Any]!
    var trailerKey = [[String:Any]]()

    @IBOutlet var trailerVideo: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trailerIDInfo = self.trailerKey[0]
        let trailerID = trailerIDInfo["key"] as! String
        let url = URL(string: "https://www.youtube.com/watch?v=\(trailerID)")
        trailerVideo.loadRequest(URLRequest(url: url!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieID = movie["id"] as! String
        
        let url = URL(string: "http://api.themoviedb.org/3/movie/" + movieID + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.trailerKey = dataDictionary["results"] as! [[String:Any]]
            }
        }
        task.resume()
    }
}
