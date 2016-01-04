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
    let testData = [1, 2, 3, 4, 5, 6, 7]
    let daysOfTheWeek = NSDateFormatter().shortWeekdaySymbols
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let barLabelUpdateNotification = NSNotification(name: "deleteOldBarLabels", object: nil)
    
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
        let marginX = width/12 // Buffer around of the graph
        let marginY = height/6
        let graphBounds = CGRect(x: rect.origin.x + marginX,
            y: rect.origin.y + marginY,
            width: width - marginX * 2,
            height: height - marginY)
        let path = UIBezierPath(rect: rect)
        // Remove previous BarLabels
        notificationCenter.postNotification(barLabelUpdateNotification)
        // Color in background
        graphColor.setFill()
        path.fill()
        
        // Dimensions of each bar representing a datapoint defined
        let dataBarMargin = graphBounds.width / (CGFloat(testData.count) * (barToSpaceRatio + 1) - 1)
        let dataBarWidth = dataBarMargin * barToSpaceRatio
        let maxDataValue = testData.maxElement()
        // Loop positions/sizes each bar
        for var i = 0; i < testData.count; i++ {
            let originX: CGFloat = graphBounds.origin.x + dataBarMargin * CGFloat(i) + dataBarWidth * CGFloat(i)
            let barHeight = graphBounds.height  * CGFloat(testData[i]) / CGFloat(maxDataValue!)
            
            let bar = CGRect(origin: CGPoint(x: originX, y: graphBounds.origin.y + graphBounds.height - barHeight), size: CGSize(width: dataBarWidth, height: barHeight))
            let path = UIBezierPath(rect: bar)
            //Draw data bar
            barColor.setFill()
            path.fill()
            
            // Bar label added below
            let label = BarChartLabel(frame: CGRect(x: originX, y: 0.0, width: dataBarWidth, height: marginY), notificationName: barLabelUpdateNotification.name)
            label.text = daysOfTheWeek[i]
            label.adjustsFontSizeToFitWidth = true
            addSubview(label)
        }
        
        //set up the graph baseline
        let graphPath = UIBezierPath()
        graphPath.lineWidth = 3.0
        //go to start of line
        graphPath.moveToPoint(CGPoint(x: width / 25, y: height - graphPath.lineWidth/2)) // Can probably be refactored
        //Connect to other point
        graphPath.addLineToPoint(CGPoint(x: width * 24/25, y: height - graphPath.lineWidth/2))
        //Draw line
        UIColor.blackColor().setStroke()
        graphPath.stroke()
        

    }

}
