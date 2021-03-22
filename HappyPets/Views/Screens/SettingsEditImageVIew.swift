//
//  SettingsEditImageVIew.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 17/03/21.
//

import SwiftUI

struct SettingsEditImageVIew: View {
    @State var title:String
    @State var description: String
    @State var selectedImage: UIImage //Image shown on this screen
    @State var imagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Text(description)
                Spacer(minLength: 0)
            }

            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
            Button(action: {
                imagePicker.toggle()
            }, label: {
                Text("Import Photo".uppercased())
                    .font(.title3)
                .fontWeight(.bold)
                    .padding()
                    .frame(height:60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $imagePicker, content: {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
            })
            
            
            Button(action: {
                
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height:60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.yellowColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth:.infinity)
        .navigationBarTitle(title)
    }
}

struct SettingsEditImageVIew_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SettingsEditImageVIew(title: "Title", description: "Description", selectedImage: UIImage(named:"dog1")!)
        }
    }
}
