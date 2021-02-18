//
//  ImagePicker.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 13/02/21.
//

import Foundation
import SwiftUI

struct ImagePicker:UIViewControllerRepresentable {
    
    @Binding var imageSelected: UIImage
    @Environment(\.presentationMode) var presentationMode
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(parent: self)
    }
    
    class ImagePickerCordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent : ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage{
                //select the image for our app
                parent.imageSelected = image
                
                //dismiss the screen
                parent.presentationMode.wrappedValue.dismiss()
                
            }
        }
        
    }
}
