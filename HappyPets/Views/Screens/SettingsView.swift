//
//  SettingsView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 17/03/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
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
                        destination: SettingsEditTextView(submissionText: "Current Display Name", title: "Display Name", placeholder: "Your display name here...", description: "You can edit your display name here. This will be seen bhy other user on your profile and on your posts."),
                        label: {
                            SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                        })
                    
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: "Current Bio Here", title: "Profile Bio", placeholder: "Your bio here...", description: "Your bio is a great place to let other users know a little about you. It will bw shown on your profile only."),
                        label: {
                            SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                        })
                    
                    SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
                    
                })
                .padding()
                
                
                //MARK:- SECTION 3: Application
                
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.MyTheme.yellowColor)
                    SettingsRowView(leftIcon: "globe", text: "HappyPets Website", color: Color.MyTheme.yellowColor)
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
