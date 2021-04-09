//
//  AuthService.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 07/04/21.
//

//Used to Authenticate Users in Firebase
//Used to Handle User accounts in Firebase
import Foundation
import FirebaseAuth
import FirebaseFirestore //database

let DB_BASE = Firestore.firestore()

class AuthService {
    
    
    // MARK:- Properties
    
    static let instance = AuthService()
    
    private var REF_USERS = DB_BASE.collection("users")
    
    // MARK:- AUTH USER FUNCTIONS
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool,_ isNewUser: Bool?,_ userID: String?) -> ()){
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            //check for error
            if error != nil{
                print("Error logging in to Firebase.")
                handler(nil, true, nil, nil)
                return
            }
            
            //check for providerID
            guard let providerId = result?.user.uid else {
                print("Error getting provider Id")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerId) { (returnedUserID) in
                if let userID = returnedUserID{
                    //User already exist, log in to app immediately
                    handler(providerId, false, false, userID)
                }
                else{
                    //User doesn't exist, Continue to onboarding a new user
                    handler(providerId, false, true, nil)
                }
            }
        }
    }
    
    func logInUserToApp(userID: String, handler:@escaping (_ success:Bool) -> ()) {
        
        //Get the User's info
        getUserInfo(forUserID: userID) { (returnedName, returnedBio) in
            if let name = returnedName , let bio = returnedBio{
                //SUCCESS
                print("Success getting user info while logging in")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    //Set the User's info into our app
                    UserDefaults.standard.setValue(userID, forKey: CurrentUserDefault.userID)
                    UserDefaults.standard.setValue(bio, forKey: CurrentUserDefault.bio)
                    UserDefaults.standard.setValue(name, forKey: CurrentUserDefault.displayName)
                }
            }
            else{
                //ERROR
                print("Error getting user info while logging in")
                handler(false)
            }
        }
    }
    
    
    func logOutUser(handler: @escaping (_ sucees: Bool) -> ()){
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error in sign out \(error)")
            handler(false)
            return
        }
        handler(true)
        
        //Update UserDefaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { (keys) in
                UserDefaults.standard.removeObject(forKey: keys)
            }
        }
    }
    
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> ()) {
        
        //Set up a user Document within the user Collection
        let document = REF_USERS.document()
        let userID = document.documentID
        
        //Upload profile image to storage
        ImageManager.instance.uploadImage(userID: userID, image: profileImage)
        
        //Upload profile data to Firestore
        let userData : [String: Any] = [
            DatabaseUserField.displayName: name,
            DatabaseUserField.email: email,
            DatabaseUserField.providerID: providerID,
            DatabaseUserField.provider:provider,
            DatabaseUserField.userID:userID,
            DatabaseUserField.bio: "This is ChetakON COOL Bio",
            DatabaseUserField.dateCreated: FieldValue.serverTimestamp()
        ]
        
        document.setData(userData) { (error) in
            if let error = error{
                //ERROR
                print("Error uploading data to user document")
                handler(nil)
            }
            else{
                //SUCCESS
                handler(userID)
            }
        }
    }
    
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_  existingUserID: String?) -> ()){
        //If a userID is returned then the user does exist in our database
        REF_USERS.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { (querrySnapshot, error) in
            if let snapShot = querrySnapshot, snapShot.count > 0, let document = snapShot.documents.first {
                //SUCCESS
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            }
            else{
                //ERROR, NEW USER
                handler(nil)
                return
            }
        }
    }
    
    // MARK:- GET USER FUNCTIONS
    
    func getUserInfo(forUserID userID: String, handler: @escaping(_ name: String?, _ bio:String?) -> ()) {
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            
            if let document = documentSnapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                print("Success getting user info")
                handler(name,bio)
                return
            }
            else{
                print("Error gettting user info")
                handler(nil, nil)
                return
            }
            
        }
    }
}

