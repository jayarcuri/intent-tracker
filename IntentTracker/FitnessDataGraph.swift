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
    let daysOfTheWeek = NSDateFormatter().shortWeekdaySymbols
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let barLabelUpdateNotification = "deleteOldBarLabels"
    
    let barToSpaceRatio: CGFloat = 6 // (to one)
    
/*    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    override func drawRect(rect: CGRect) {
        // Initial Declarations
        let width = rect.width
        let height = rect.height
        let marginY = height/5 // Buffer around of the graph
        let graphBounds = CGRect(x: rect.origin.x + marginY,
            y: rect.origin.y + marginY,
            width: width - marginY * 2,
            height: height - marginY * 2)
        let path = UIBezierPath(rect: rect)
        
        graphColor.setFill()
        path.fill()
        
        // Dimensions of each bar representing a datapoint defined here
        let dataBarMargin = graphBounds.width / (CGFloat(testData.count) * (barToSpaceRatio + 1) - 1)
        let dataBarWidth = dataBarMargin * barToSpaceRatio
        let maxDataValue = testData.maxElement()
        
        for var i = 0; i < testData.count; i++ {
            let originX: CGFloat = graphBounds.origin.x + dataBarMargin * CGFloat(i) + dataBarWidth * CGFloat(i)
            let barHeight = graphBounds.height  * CGFloat(testData[i]) / CGFloat(maxDataValue!)
            
            let bar = CGRect(origin: CGPoint(x: originX, y: graphBounds.origin.y + graphBounds.height - barHeight), size: CGSize(width: dataBarWidth, height: barHeight))
            let path = UIBezierPath(rect: bar)
            
            barColor.setFill()
            path.fill()
            
            // Bar label added below
            let label = BarChartLabel(frame: CGRect(x: originX, y: 0.0, width: dataBarWidth, height: dataBarWidth), notificationName: barLabelUpdateNotification)
            label.text = daysOfTheWeek[i].uppercaseString
            label.adjustsFontSizeToFitWidth = true
            addSubview(label)
        }
    }

}
