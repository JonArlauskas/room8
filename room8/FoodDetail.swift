//
//  FoodDetail.swift
//  room8
//
//  Created by Jonathan Arlauskas on 2015-09-14.
//  Copyright (c) 2015 Jonathan Arlauskas. All rights reserved.
//

import UIKit

class FoodDetail: UIView {
    
    
    let animationDuration = 0.5
    
    init(item: Food) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        alpha = 0.0
    
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func show() {
        
        if superview != nil {
            return
        }
        
        UIApplication.sharedApplication().delegate?.window??.addSubview(self)
        UIView.animateWithDuration(animationDuration) {
            self.alpha = 1
        }
        
    }
    
    
    func hide() {
       self.removeFromSuperview()
    }
    
    
    
    
    

}
