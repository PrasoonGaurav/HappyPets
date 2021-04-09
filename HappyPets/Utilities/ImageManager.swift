//
//  ImageManager.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 08/04/21.
//

import Foundation
import FirebaseStorage  //holds images and videos

class ImageManager{
    
    // MARK:- Properties
    
    static let instance = ImageManager()
    
    private var REF_STOR = Storage.storage()
    
    // MARK:- Public Functions
    //functions we call from other places in the app
    
    func uploadImage(userID: String, image: UIImage) {
        
        //Get the path where we will save the image
        let path = getProfileImagePath(userID: userID)
        
        //Save image to path
        uploadImage(path: path, image: image) { (_) in }
    }
    
    // MARK:- Public Functions
    //functions we call from this file only
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        var compression:CGFloat = 1.0   //Loops down by 0.05
        let maxFileSize:Int = 240*240  //maximum file size we want to save
        let maxCompression:CGFloat = 0.05 //max compression that we allow for HappyPets
        
        //get image data
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        //check maximum file size
        while(originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression){
                originalData = compressedData
            }
            print(compression)
        }
        
        
        //get image data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        //get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //save data to path
        path.putData(finalData, metadata: metadata) { (_, error) in
            if let error = error {
                //ERROR
                print("Error uploading the image. \(error)")
                handler(false)
                return
            }
            else{
                //SUCCESS
                print("Success uploading the image")
                handler(true)
                return
            }
        }
    }
}
