////
//  HomeViewController.swift
//  AutoSwipe
//
//  Created by Chris Talley on 6/18/15.
//  Copyright (c) 2015 Chris Talley. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    var cards = Array<Card>()
    var currIndex = 0
    var panRecognizer: UIPanGestureRecognizer?
    var topCard: Card {
        get {
            return self.cards[currIndex]
        }
    }
    var topCenter: CGPoint?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for(var i=0; i<4; i++) {
            cards.append(getNextCard(i))
            if i<3 { //Don't show the last card
                self.view.addSubview(cards[i].getView())
                self.view.sendSubviewToBack(cards[i].getView())
            }
        }
        self.topCenter = CGPoint(x: topCard.getView().center.x, y: topCard.getView().center.y)
        
        
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.topCard.getView().addGestureRecognizer(panRecognizer!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeTopCard() {
        
        UIView.animateWithDuration(0.25, animations: {
            self.getCard(0).getView().center = CGPoint(x: UIScreen.mainScreen().bounds.width*2, y: 0-UIScreen.mainScreen().bounds.height*2)
            for(var i=1; i<4; i++) {
                self.getCard(i).getView().center = self.getCenter(i-1)
                if i == 3 {
                    let backCardView = self.getCard(i).getView()
                    self.view.addSubview(backCardView)
                    self.view.sendSubviewToBack(backCardView)
                    backCardView.hidden = false
                }
                
            }
            //a!.transform = CGAffineTransformMakeRotation(0)
            
            return
            }, completion: {
                (value: Bool) in
                let oldFront = self.getCard(0).getView()
                oldFront.removeFromSuperview()
                oldFront.transform = CGAffineTransformMakeRotation(0)
                oldFront.center = self.getCenter(3)
                //oldFront.backgroundColor = UIColor.brownColor()
                oldFront.hidden = true
                self.view.addSubview(oldFront)
                self.view.sendSubviewToBack(oldFront)
                self.currIndex += 1
                //self.getCard(0).getView().backgroundColor = UIColor.redColor()
                oldFront.removeGestureRecognizer(self.panRecognizer!)
                self.getCard(0).getView().addGestureRecognizer(self.panRecognizer!)
                
        })
        
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        let screenSize = UIScreen.mainScreen().bounds.width
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            if recognizer.state == UIGestureRecognizerState.Ended {
                var distanceDragged = view.center.x - getCenter(0).x
                var percentDragged = distanceDragged/CGFloat(UIScreen.mainScreen().bounds.width)
                if percentDragged > 0.25 {
                    removeTopCard()
                }
                else {
                    UIView.animateWithDuration(0.4, animations: {
                        view.center = self.getCenter(0)
                        view.transform = CGAffineTransformMakeRotation(0)
                        return
                    })
                }
            }
            else {
                view.center = CGPoint(x:view.center.x + translation.x,
                    y:view.center.y + translation.y/8)
                let amountToRotate = translation.x / CGFloat(UIScreen.mainScreen().bounds.width) * 0.4
                view.transform = CGAffineTransformMakeRotation((amountToRotate * 180.0 * CGFloat(M_PI)) / 180.0)
            }
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func getNextNewCard() -> Card {
        return getNextCard(3)
    }
    
    func getNextCard(index: Int) -> Card {
        let ind = min(2,index)
        return Card(url: "http://masterherald.com/wp-content/uploads/2014/12/2015-Subaru-WRX.jpg", xD: ind*2, yD:ind*2)
    }
    
    func getCenter(index: Int) -> CGPoint {
        let ind = min(2,index)
        return CGPoint(x: self.topCenter!.x + CGFloat(2*ind), y: self.topCenter!.y + CGFloat(2*ind))
    }
    
    func promote() {
        let oldTop = topCard
        
    }
    
    func getCard(index: Int) -> Card {
        return self.cards[(currIndex + index) % 4]
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
}
