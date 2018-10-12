//
//  CircularSpinnerBackdrop.swift
//  Shack15
//
//  Created by Drew Barnes on 07/10/2018.
//  Copyright © 2018 Ampersand Technologies Ltd. All rights reserved.
//

import UIKit

public class AMProgressHUD: UIView {

    fileprivate let kSlideInOutAnimationDuration: TimeInterval = 0.3
    fileprivate let kDisolveAnimationDuration: TimeInterval = 0.3
    
    fileprivate var backgroundView: UIVisualEffectView?
    fileprivate let childView = Renderer.fromNib()
    
    public static let shared = AMProgressHUD()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.noAlpha()
        self.createBackground()
        self.setupChildView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setupChildView()
    }
    
    @objc func setupChildView() {
        if !self.subviews.contains(childView) {
            var frame = self.childView.frame
            frame.size.width = UIScreen.main.bounds.width
            self.childView.frame = frame
            
            self.childView.center = CGPoint(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height / 2
            )
            self.childView.backgroundColor = .clear
            self.addSubview(childView)
        }
        
    }
    
    @objc func createBackground() {
        self.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.backgroundView?.frame = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        self.backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView?.alpha = 0
    }
    
    @objc func addBackgroundView() {
        if let bgView = self.backgroundView {
            bgView.removeFromSuperview()
            UIApplication.shared.keyWindow?.insertSubview(bgView, belowSubview: self)
        }
    }
    
}

extension AMProgressHUD {
    
    @objc public func show() {
        self.childView.textLabel.isHidden = true
        self.childView.centerConstraint.constant = 0
        self.showInSuperviewWithCompletion(
            UIApplication.shared.keyWindow!,
            completion: {}, animated: true
        )
    }
    
    @objc public func show(message: String) {
        self.childView.textLabel.text = message
        self.childView.centerConstraint.constant = -23
        self.childView.textLabel.isHidden = false
        self.showInSuperviewWithCompletion(
            UIApplication.shared.keyWindow!,
            completion: {}, animated: true
        )
    }
    
    @objc func showInSuperviewWithCompletion(_ superView: UIView, completion: () -> Void, animated: Bool) {
        
        var slideInOutAnimationDuration: TimeInterval = 0.0
        slideInOutAnimationDuration = animated ? kSlideInOutAnimationDuration : 0
        
        var dissolveAnimationDuration: TimeInterval = 0.0
        dissolveAnimationDuration = animated ? kDisolveAnimationDuration : 0
        
        // Blocking views underneath
        for subview in superView.subviews {
            if subview.isKind(of: Renderer.self) {
                subview.isUserInteractionEnabled = true
            } else if subview.isDescendant(of: self) {
                subview.isUserInteractionEnabled = true
            } else {
                subview.isUserInteractionEnabled = false
            }
        }
        superView.addSubview(self)
        
        self.setupChildView()
        self.addBackgroundView()
        self.childView.animate()
        
        UIView.animate(withDuration: slideInOutAnimationDuration, animations: {
            self.fullAlpha()
        }, completion: { (_: Bool) in
            UIView.animate(withDuration: dissolveAnimationDuration, animations: {
                self.backgroundView?.alpha = 1
            })
        })
        
    }
    
    @objc public func hide() {
        hideInSuperviewWithCompletion(
            UIApplication.shared.keyWindow!, completion: {
        }, animated: true
        )
    }
    
    @objc func hideInSuperviewWithCompletion(_ superView: UIView, completion: () -> Void, animated: Bool) {
        
        var slideInOutAnimationDuration: TimeInterval = 0.0
        slideInOutAnimationDuration = animated ? kSlideInOutAnimationDuration : 0
        
        var dissolveAnimationDuration: TimeInterval = 0.0
        dissolveAnimationDuration = animated ? kDisolveAnimationDuration : 0
        
        // Blocking views underneath
        for subview in superView.subviews {
            subview.isUserInteractionEnabled = true
        }
        
        UIView.animate(withDuration: dissolveAnimationDuration, animations: {
            self.backgroundView?.alpha = 0
        }, completion: { (_: Bool) in
            
            UIView.animate(withDuration: slideInOutAnimationDuration, animations: {
                
                self.backgroundView?.alpha = 0
                self.noAlpha()
                //self.backgroundView?.removeFromSuperview()
                //self.backgroundView = nil
                
            }, completion: { (_: Bool) in
                self.removeFromSuperview()
            })
            
        })
        
    }
    
    // MARK: - Helpers
    @objc func noAlpha() {
        self.alpha = 0.0
    }
    
    @objc func fullAlpha() {
        self.alpha = 1.0
    }

}

