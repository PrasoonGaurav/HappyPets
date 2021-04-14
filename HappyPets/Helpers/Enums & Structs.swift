//
//  Enums & Structs.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 08/04/21.
//

import Foundation

//Fields within the User Document in Database
struct DatabaseUserField {
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}

//Fields within the Post Document in Database
struct DatabasePostField {
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likesCount = "likes_count" //int
    static let likedBy = "liked_by" //array of userID
    static let comments = "comments" //sub-collection
}

//Fields within the Comment sub-collection of post document
struct DatabaseCommentField {
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"
}

//Fields within the Report Document in Database
struct DatabaseReportsField {
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated = "date_created"
}

//Fields for UserDefaults saved within the app
struct CurrentUserDefault {
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
