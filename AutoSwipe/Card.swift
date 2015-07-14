//
//  Card.swift
//  AutoSwipe
//
//  Created by Chris Talley on 6/22/15.
//  Copyright (c) 2015 Chris Talley. All rights reserved.
//

import Foundation
import UIKit


class Card {
    
    var cardView: UIView
    var imageView: UIImageView
    var imageURL: String
    var xDelta = 0
    var yDelta = 0
    let cardWidth = UIScreen.mainScreen().bounds.width * 0.75
    let cardHeight = UIScreen.mainScreen().bounds.height * 0.5
    var x: Int {
        get {
            return Int((UIScreen.mainScreen().bounds.width - cardWidth)/2) + xDelta
        }
    }
    var y: Int {
        get {
            return Int((UIScreen.mainScreen().bounds.height - cardHeight)/2.5) + yDelta
        }
    }
    
    
    convenience init(url: String) {
        self.init(url: url, xD: 0, yD: 0)
    }
    
    init(url: String, xD: Int, yD: Int) {
        self.xDelta = xD
        self.yDelta = yD
        self.imageURL = url
        self.imageView = UIImageView(frame: CGRect(x: 1, y: 1, width: cardWidth - 2, height: cardHeight*0.5))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.cardView = UIView()
        self.cardView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: cardWidth, height: cardHeight)
        
        self.cardView.layer.cornerRadius = 12.0
        self.cardView.layer.borderWidth = 0.5
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        self.cardView.clipsToBounds = true
        
        self.cardView.addSubview(imageView)
        fillCarImage(url, imageView: imageView)
    }
    
    
    
    
    func getView() -> UIView {
        return self.cardView
    }
    
    func fillCarImage(url: String, imageView: UIImageView) {
        let imgURL: NSURL? = NSURL(string: url)
        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data)
                if image != nil {
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = image!
                        self.imageView.clipsToBounds = true
                    })
                }
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
    }
    
    
    func getJSON(url: String) {
        
    }
    
}