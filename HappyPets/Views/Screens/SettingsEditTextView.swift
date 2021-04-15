//
//  SettingsEditTextView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 17/03/21.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var title:String
    @State var placeholder: String
    @State var description: String
    @State var settignsEditTextOption : SettingsEditTextOption
    @Binding var profileText: String
    @AppStorage(CurrentUserDefault.displayName) var currentUserID: String?
    @State var showSuccessAlert:Bool = false
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack{
            
            HStack{
                Text(description)
                
                Spacer(minLength: 0)
            }
            
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height:60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            
            
            Button(action: {
                if textIsAppropriate(){
                    saveText()
                }
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height:60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth:.infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            return Alert(title: Text("Saved 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                dismissView()
            }))
        }
    }
    
    //MARK:- FUNCTIONS
    func dismissView(){
        self.presentationMode.wrappedValue.dismiss()
        self.haptics.notificationOccurred(.success)
    }
    
    func textIsAppropriate() -> Bool {
        // For example:-
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check if the text has inappropraite things
        
        //Checkingfor bad words
        let badWordsArray = ["Fuck", "Ass"]
        let words = submissionText.components(separatedBy: " ")
        for word in words{
            if badWordsArray.contains(word){
                return false
            }
        }
        
        //Checking for minimum character count
        if submissionText.count < 3{
            return false
        }
        return true
    }
    
    func saveText(){
        guard let userID = currentUserID else { return }
        
        switch settignsEditTextOption {
        case .displayName:
            //Update the UI on the Profile
            self.profileText = submissionText
            
            //Update the UserDefaults
            UserDefaults.standard.setValue(submissionText, forKey: CurrentUserDefault.displayName)
            
            //Update on all user's Posts
            DataService.instance.updateDisplayNameOnPost(userID: userID, displayName: submissionText)
            
            //Update on the user's profile in Database
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { (success) in
                if success{
                    self.showSuccessAlert.toggle()
                }
            }
        case .bio:
            //Update the UI on the Profile
            self.profileText = submissionText
            
            //Update the UserDefaults
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefault.bio)
            
            //Update on the user's profile in Database
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { (success) in
                if success{
                    self.showSuccessAlert.toggle()
                }
            }
        }
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var text : String = ""
    static var previews: some View {
        NavigationView{
            SettingsEditTextView(title: "Test Title", placeholder: "Test Placeholder", description: "This is a Description", settignsEditTextOption: .displayName, profileText: $text)
                .preferredColorScheme(.light)
        }
    }
}
