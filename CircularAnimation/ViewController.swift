//
//  ViewController.swift
//  CircularAnimation
//
//  Created by Sarthak Mishra on 09/07/18.
//  Copyright © 2018 Sarthak Mishra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var shapeLayer: CAShapeLayer?
    var pulsatingLayer: CAShapeLayer!
    var counter = 0
    var timer = Timer()
    
    let pcTag: UILabel = {
        let label = UILabel()
        label.text = "Completed"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    
    let peecentageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Start"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    fileprivate func setUpPulsatingLayer(_ circularPath: UIBezierPath) {
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 15
        pulsatingLayer.fillColor = UIColor.init(red: 86/255, green: 30/255, blue: 63/255, alpha: 1).cgColor
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        
        
        view.layer.addSublayer(pulsatingLayer)
        
        animatePulsatingLayer()
    }
    
    fileprivate func setUpTrackLayer(_ circularPath: UIBezierPath) {
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.init(red: 157/255, green: 52/255, blue: 89/255, alpha: 1).cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.black.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
    }
    
    fileprivate func setUpShapeLayer(_ circularPath: UIBezierPath) {
        shapeLayer = CAShapeLayer()
        shapeLayer?.path = circularPath.cgPath
        shapeLayer?.strokeColor = UIColor.init(red: 214/255, green: 29/255, blue: 94/255, alpha: 1).cgColor
        shapeLayer?.lineWidth = 15
        shapeLayer?.position = view.center
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineCap = kCALineCapRound
        shapeLayer?.strokeEnd = 0
        shapeLayer?.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNotificationObeservers()
        view.backgroundColor = UIColor.black
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi , clockwise: true)
        
        
        
        
        setUpPulsatingLayer(circularPath)
        setUpTrackLayer(circularPath)
        setUpShapeLayer(circularPath)
        
        
    
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(pcTag)
        view.addSubview(peecentageLabel)
        peecentageLabel.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        peecentageLabel.center = view.center
        
        pcTag.frame = CGRect(x: peecentageLabel.center.x-50, y: peecentageLabel.center.y+5, width: 100, height: 40)
    }
    
    func setUpNotificationObeservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    @objc func handleEnterForeground()
    {
       animatePulsatingLayer()
    
    
    }
    func animatePulsatingLayer()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "bounceanim")
        
        
    }
    func displayTextDuration()
    {
        
        shapeLayer?.strokeEnd = 0
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
    }
    @objc func timerAction()
    {
       
        counter += 1
        if(counter==60)
        {
            timer.invalidate()
            
        }
        
        let percentage = CGFloat(counter) / CGFloat(60)
        DispatchQueue.main.async {
            self.peecentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer?.strokeEnd = percentage
         }
        
        print("E: \(percentage)")
        
        
    }
    func animateCircle()
    {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer?.add(basicAnimation, forKey: "basic")
    }
    @objc func handleTap()
    {
        shapeLayer?.strokeEnd = 0
        peecentageLabel.text = "0%"
        counter = 0
        //fab03c
        displayTextDuration()
//        animateCircle()
    }
    
}

