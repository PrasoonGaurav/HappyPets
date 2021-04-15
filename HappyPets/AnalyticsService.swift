//
//  AnalyticsService.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 16/04/21.
//

import Foundation
import FirebaseAnalytics

class AnalyticService{
    
    static let instance = AnalyticService()
        
    func likePostDoubleTap(){
        Analytics.logEvent("like_double_tap", parameters: nil)
    }
    
    func likePostHeartPressed(){
        Analytics.logEvent("like_heart_pressed", parameters: nil)
    }
}
