//
//  BarChartLabel.swift
//  IntentTracker
//
//  Created by Adam Mullarkey on 1/3/16.
//  Copyright © 2016 Intent Watch. All rights reserved.
//

import UIKit

class BarChartLabel: UILabel {
    
    
    init(frame: CGRect, notificationName: String) {
        super.init(frame: frame)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        //notificationCenter.addObserver(self, selector: <#T##Selector#>, name: <#T##String?#>, object: <#T##AnyObject?#>)
        let mainQueue = NSOperationQueue.mainQueue()
        var 🔥 = notificationCenter.addObserverForName(notificationName, object: nil, queue: mainQueue) { _ in notificationCenter.removeObserver(self, forKeyPath: UITextFieldTextDidChangeNotification)
            self.removeFromSuperview()
        }
        textColor = UIColor.orangeColor()
        textAlignment = NSTextAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
