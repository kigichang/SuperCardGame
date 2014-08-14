//
//  ViewController.swift
//  SuperCardGame
//
//  Created by kigi on 8/13/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: Properties
    
    
    @IBOutlet var playingCardView: PlayingCardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playingCardView.addGestureRecognizer(UIPinchGestureRecognizer(target: self.playingCardView, action: "pinch:"))
        playingCardView.card = Card.rand()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        
        if !self.playingCardView.faceUp {
            self.playingCardView.card = Card.rand()
        }
        self.playingCardView.faceUp = !self.playingCardView.faceUp
    }
    
    /*
    // 可以用 storyboard 拉 Pinch Gesture 進來，像 Swipe Gesture
    @IBAction func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Changed || sender.state == UIGestureRecognizerState.Ended {
            self.playingCardView.faceCardScaleFactor *= sender.scale
            
            sender.scale = 1.0
        }
    }
    */
}

