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
    var lastTouchX: CGFloat = CGFloat(0)
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
    
    func removeTopCard(keep: Bool) {
        let rightOrLeft: CGFloat = keep ? CGFloat(2) : CGFloat(-2)
        UIView.animateWithDuration(0.25, animations: {
            self.getCard(0).getView().center = CGPoint(x: UIScreen.mainScreen().bounds.width*rightOrLeft, y: 0-UIScreen.mainScreen().bounds.height*2)
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
                if abs(percentDragged) > 0.35 {
                    removeTopCard(percentDragged > 0)
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
                if recognizer.state == UIGestureRecognizerState.Began {
                    lastTouchX = recognizer.locationInView(self.view).x
                }
                view.center = CGPoint(x:view.center.x + translation.x,
                    y:view.center.y + translation.y/8)
                var currentTouch = recognizer.locationInView(self.view)
                var dx = currentTouch.x - lastTouchX
                let amountToRotate = dx/(self.view.frame.width * 0.25)
                view.transform = CGAffineTransformMakeRotation((amountToRotate * 10 * CGFloat(M_PI)) / 180.0)
            }
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func getNextNewCard() -> Card {
        return getNextCard(3)
    }
    
    func getNextCard(index: Int) -> Card {
        let ind = min(2,index)
        return Card(url: "http://cdntbs.astonmartin.com/sitefinity/15MY/vanq15myhero.jpg", xD: ind*2, yD:ind*2)
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
