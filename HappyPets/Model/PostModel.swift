//
//  PostModel.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import Foundation
import SwiftUI

struct PostModel:Identifiable, Hashable {
    
    var id = UUID()
    var postID: String     //ID of the post in the database
    var userId: String     //ID of the user in the database
    var userName: String   //Username of user in the database
    var captions: String?
    var dateCreated: Date
    var likeCount:Int
    var likedByUser:Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
