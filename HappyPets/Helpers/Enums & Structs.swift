//
//  Enums & Structs.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 08/04/21.
//

import Foundation

//Fields within the User Document in database
struct DatabaseUserField {
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}

//Fields within the Post document in database
struct DatabasePostField {
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
}

//Fields for user defaults saved within the app
struct CurrentUserDefault {
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
