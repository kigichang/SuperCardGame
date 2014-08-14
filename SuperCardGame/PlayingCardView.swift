//
//  PlayingCardView.swift
//  SuperCardGame
//
//  Created by kigi on 8/13/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import UIKit

// MARK: Global Constants
let CORNER_FONT_STANDARD_HEIGHT = CGFloat(180.0)
let CORNER_RADIUS = CGFloat(12.0)
let CORNER_OFFSET = CGFloat(3.0)
let DEFAULT_FACE_CARD_SCALE_FACTOR = CGFloat(0.90)
let MY_PI = CGFloat(M_PI)

let PIP_HOFFSET_PERCENTAGE = CGFloat(0.165)
let PIP_VOFFSET1_PERCENTAGE = CGFloat(0.090)
let PIP_VOFFSET2_PERCENTAGE = CGFloat(0.175)
let PIP_VOFFSET3_PERCENTAGE = CGFloat(0.270)
let PIP_FONT_SCALE_FACTOR = CGFloat(0.012)


class PlayingCardView: UIView {
    
// MARK: Prpoerties
    
    // FIXME: 嘿嘿
    var card: Card = Card(rank: .King, suit: .Heart) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // TODO: 哈哈
    var faceUp: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var faceCardScaleFactor: CGFloat = DEFAULT_FACE_CARD_SCALE_FACTOR {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
// MARK: Pips
    internal func drawPipsWithHorizontalOffset(hoffset: CGFloat, verticalOffset: CGFloat, upsideDown: Bool) {
    
        if upsideDown {
            self.pushContextAndRotateUpSideDown()
        }
        
        var middle = CGPointMake(self.bounds.size.width / CGFloat(2.0), self.bounds.size.height / CGFloat(2.0))
        var pipFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        pipFont = pipFont.fontWithSize(pipFont.pointSize * self.bounds.size.width * PIP_FONT_SCALE_FACTOR)
        var attributedSuit = NSAttributedString(string: "\(self.card.suit)", attributes: [NSFontAttributeName : pipFont])
        var pipSize = attributedSuit.size()
        
        var pipOrigin = CGPointMake(
                            middle.x - pipSize.width / CGFloat(2.0) - hoffset * self.bounds.size.width,
                            middle.y - pipSize.height / CGFloat(2.0) - verticalOffset * self.bounds.size.height)
        
        attributedSuit.drawAtPoint(pipOrigin)
        
        if hoffset != 0.0 {
            pipOrigin.x += hoffset * CGFloat(2.0) * self.bounds.size.width
            attributedSuit.drawAtPoint(pipOrigin)
        }
        
        if upsideDown {
            self.popContext()
        }
    }
    
    internal func drawPipsWithHorizontalOffset(hoffset: CGFloat, verticalOffset: CGFloat, mirroredVertically: Bool) {
        self.drawPipsWithHorizontalOffset(hoffset, verticalOffset: verticalOffset, upsideDown: false)
        
        if mirroredVertically {
            self.drawPipsWithHorizontalOffset(hoffset, verticalOffset: verticalOffset, upsideDown: true)
        }
    }
    
    internal func drawPips() {
        let rank = self.card.rank
        
        if rank == Rank.Ace || rank == Rank.Five || rank == Rank.Nine || rank == Rank.Three {
            self.drawPipsWithHorizontalOffset(0, verticalOffset: 0, mirroredVertically: false)
        }
        
        
        if rank == Rank.Six || rank == Rank.Seven || rank == Rank.Eight {
            self.drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, verticalOffset: 0, mirroredVertically: false)
        }
        
        if rank == Rank.Two || rank == Rank.Three || rank == Rank.Seven || rank == Rank.Eight || rank == Rank.Ten {
            self.drawPipsWithHorizontalOffset(0, verticalOffset: PIP_VOFFSET2_PERCENTAGE, mirroredVertically: rank != Rank.Seven)
        }
        
        if rank == Rank.Four || rank == Rank.Five || rank == Rank.Six || rank == Rank.Seven || rank == Rank.Eight || rank == Rank.Nine || rank == Rank.Ten {
            self.drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, verticalOffset: PIP_VOFFSET3_PERCENTAGE, mirroredVertically: true)
        }
        
        if rank == Rank.Nine || rank == Rank.Ten {
            self.drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, verticalOffset: PIP_VOFFSET1_PERCENTAGE, mirroredVertically: true)
        }
        
    }
    
    
// MARK: Drawing
    
    internal func cornerScaleFactor() -> CGFloat {
        return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT
    }
    
    internal func cornerRadius() -> CGFloat {
        return self.cornerScaleFactor() * CORNER_RADIUS
    }
    
    internal func cornerOffset() -> CGFloat {
        return self.cornerRadius() / CORNER_OFFSET
    }
    
    internal func pushContextAndRotateUpSideDown() {
        var context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, self.bounds.width, self.bounds.height)
        CGContextRotateCTM(context, MY_PI)
    }
    
    internal func popContext() {
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }
    
    internal func drawCorners() {
        var paragraphStype = NSMutableParagraphStyle()
        paragraphStype.alignment = .Center
        
        var cornerFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cornerFont = cornerFont.fontWithSize(cornerFont.pointSize * self.cornerScaleFactor())
        
        var cornerText = NSAttributedString(string: "\(self.card.rank)\n\(self.card.suit)", attributes: [NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStype])
        
        var textBounds = CGRect()
        textBounds.origin = CGPointMake(self.cornerOffset(), self.cornerOffset())
        textBounds.size = cornerText.size()
        cornerText.drawInRect(textBounds)
        
        self.pushContextAndRotateUpSideDown()
        cornerText.drawInRect(textBounds)
        self.popContext()
        
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Changed || gesture.state == UIGestureRecognizerState.Ended {
            self.faceCardScaleFactor = self.faceCardScaleFactor * gesture.scale
            gesture.scale = 1.0
        }
    }
    
    /*
    func swipe(sender: UISwipeGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Changed || sender.state == UIGestureRecognizerState.Ended {
            if !self.faceUp {
                self.card = Card.rand()
            }
            self.faceUp = !self.faceUp
        }
    }
    */
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        var roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius())
        roundedRect.addClip()
        
        UIColor.whiteColor().setFill()
        UIRectFill(self.bounds)
        
        UIColor.blackColor().setStroke()
        roundedRect.stroke()
        
        
        if self.faceUp {
            var faceImage = UIImage(named: "\(self.card.rank)\(self.card.suit)")
            
            if (nil != faceImage) {
                
                var imageRect = CGRectInset(self.bounds,
                    self.bounds.size.width * (CGFloat(1.0) - self.faceCardScaleFactor),
                    self.bounds.size.height * (CGFloat(1.0) - self.faceCardScaleFactor))
                
                faceImage.drawInRect(imageRect)
            }
            else {
                self.drawPips()
            }
            self.drawCorners()
        } // if (self.faceUp)
        else {
            UIImage(named: "cardback").drawInRect(self.bounds)
        } // if (self.faceUp) - else
    }
    
// MARK: Initialize
    
    func setup() {
        self.backgroundColor = nil
        self.opaque = false
        self.contentMode = .Redraw
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
}
