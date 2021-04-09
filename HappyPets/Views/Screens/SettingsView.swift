//
//  SettingsView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 17/03/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showSignOutError:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //MARK:- SECTION 1: HappyPets
                GroupBox(label: SettingsLabelView(labelText: "HappyPets", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        
                        Text("HappyPets is #1 app for posting pictures of your pets and sharing them across the world. We are a pets caring commuity and happy to have you!")
                            .font(.footnote)
                    })
                })
                .padding()
                
                //MARK:- SECTION 2: Profile
                
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: "Current Display Name", title: "Display Name", placeholder: "Your display name here...", description: "You can edit your display name here. This will be seen by other user on your profile and on your posts."),
                        label: {
                            SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: "Current Bio Here", title: "Profile Bio", placeholder: "Your bio here...", description: "Your bio is a great place to let other users know a little about you. It will be shown on your profile only."),
                        label: {
                            SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditImageVIew(title: "Profile Pictue", description: "Your profile picture will be shown on your profile and your post. Most users make it an image of themselves or of their pet", selectedImage: UIImage(named: "dog1")!),
                        label: {
                            SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                        })
                    
                    Button(action: {
                        signOut()
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
                    })
                    .alert(isPresented: $showSignOutError, content: {
                        return Alert(title: Text("Error Signing out!"))
                    })
                    
                })
                .padding()
                
                
                //MARK:- SECTION 3: Application
                
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "globe", text: "HappyPets Website", color: Color.MyTheme.yellowColor)
                    })
                    
                })
                .padding()
                
                
                //MARK:- SECTION 4: SIGN OFF
                
                GroupBox {
                    Text("HappyPets was made with love.\n Copyright © 2021 Prasoon Gaurav \n All rights reserved.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom,80)
            })
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.title)
                                    })
                                    .accentColor(.primary)
            )
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
    
    //   MARK:- Functions
    
    func openCustomURL(urlString: String){
        guard let url = URL(string: urlString) else {return}
        
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    func signOut(){
        AuthService.instance.logOutUser { (success) in
            if success{
                print("Sucessfully logged out from HappyPets")
                
                //Dismiss the settings view
                self.presentationMode.wrappedValue.dismiss()
            }
            else{
                print("Error logging out!")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
