//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by Drew Barnes on 06/10/2018.
//  Copyright © 2018 Ampersand Technologies Ltd. All rights reserved.
//

import UIKit

internal class Spinner: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()

    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.size.width / 2
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
            radius: ( frame.size.width - 1.5 ) / 2,
            startAngle: CGFloat( -0.5 * .pi ),
            endAngle: CGFloat( 1.5 * .pi ),
            clockwise: true
        )
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 1
        trackLayer.strokeEnd = 1
        self.layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 2.5
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0.25
        self.layer.addSublayer(progressLayer)
    }

    func animate() {
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = 0
        strokeStart.toValue = 0.99

        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0.35
        strokeEnd.toValue = 1.65
        strokeStart.isCumulative = true
        strokeEnd.isCumulative = true

        let group = CAAnimationGroup()
        group.animations = [strokeStart, strokeEnd]
        group.duration = 1

        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.repeatCount = .infinity

        progressLayer.add(group, forKey: "spinanimation")
        
    }
    

}
