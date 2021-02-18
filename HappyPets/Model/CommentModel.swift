//
//  CommentModel.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 05/02/21.
//

import Foundation
import SwiftUI

struct CommentModel:Identifiable, Hashable {
    
    var id = UUID()
    var commentId:String    //id for the comment in the database
    var userID: String
    var userName: String
    var content: String     //actual comment text
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
