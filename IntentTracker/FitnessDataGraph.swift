//
//  FitnessDataGraph.swift
//  IntentTracker
//
//  Created by Adam Mullarkey on 12/30/15.
//  Copyright © 2015 Intent Watch. All rights reserved.
//

import UIKit

@IBDesignable class FitnessDataGraph: UIView {
    
    @IBInspectable var barColor: UIColor = UIColor.blackColor()
    @IBInspectable var graphColor: UIColor = UIColor.blueColor()
    let testData = [4, 6, 3, 3, 8, 1, 5]
    
    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let marginY = height/20
        
        let bar = CGRect(origin: CGPoint(x: rect.origin.x + marginY, y: rect.origin.y + marginY), size: CGSize(width: width - marginY * 2, height: height - marginY * 2))
        let path = UIBezierPath(rect: bar)
        
        graphColor.setFill()
        path.fill()

        let dataBarMargin = (width - marginY * 2) / CGFloat(testData.count * 4 - 1)
        let dataBarWidth = dataBarMargin * 3
        let maxDataValue = testData.maxElement()
        
        for var i = 0; i < testData.count; i++ {
            let originX: CGFloat = dataBarWidth / 2 + dataBarMargin * CGFloat(i) + dataBarWidth * CGFloat(i)
            let barHeight = height * CGFloat(testData[i]) / CGFloat(maxDataValue!)
            
            let bar = CGRect(origin: CGPoint(x: originX, y: rect.origin.y + height - barHeight), size: CGSize(width: dataBarWidth, height: barHeight))
            let path = UIBezierPath(rect: bar)
            
            barColor.setFill()
            path.fill()
        }
        
    }

}
