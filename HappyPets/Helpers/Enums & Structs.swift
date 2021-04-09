//
//  Enums & Structs.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 08/04/21.
//

import Foundation

//Fields within the user Document in database
struct DatabaseUserField {
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"

}

struct CurrentUserDefault {    //Fields for user defaults saved within the app
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
