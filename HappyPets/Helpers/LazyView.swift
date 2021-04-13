//
//  LazyView.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 14/04/21.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>:View {
    var content: () -> Content
    
    var body: some View{
        self.content()
    }
}
