//
//  ViewController.swift
//  Stormy
//
//  Created by Kirill on 1/12/15.
//  Copyright (c) 2015 Kirill Pahnev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // FIXME: Get our own key at http://developer.forecast.io/ !!
    private let apiKey = "XXXXXXXX"

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
        
    }
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string:"37.8267,-122.423", relativeToURL: baseURL)
        
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location, options: nil, error: nil)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                println(currentWeather.temperature)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.iconView.image = currentWeather.icon! // This is optional so we need to unwrap it
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is" // This is optional so we need to unwrap it
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "(currentWeather.summary)"
                })
                
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                

            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //Stop refresh animation
                self.refreshActivityIndicator.stopAnimating()
                self.refreshActivityIndicator.hidden = true
                self.refreshButton.hidden = false
            })
        })
        downloadTask.resume()

    }
    
    @IBAction func refresh() {
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

