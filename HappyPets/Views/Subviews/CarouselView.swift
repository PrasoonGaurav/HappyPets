//
//  Carousel.swift
//  HappyPets
//
//  Created by Prasoon Gaurav on 06/02/21.
//

import SwiftUI

struct CarouselView: View {
    
    @State var selection:Int = 0
    
    let maxCount = 8
    @State var isTimerAdded = false
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
                    
                    ForEach(1..<maxCount) {count in
                        Image("dog\(count)")
                            .resizable()
                            .scaledToFill()
                            .tag(count)
                    }
                    
                })
            .tabViewStyle(PageTabViewStyle())
            .frame(height:300)
            .animation(.default)
            .onAppear(perform: {
                if !isTimerAdded{
                    addTimer()
                }
            })
    }
    
    func addTimer(){
        
        isTimerAdded = true
        
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            
            if selection == (maxCount - 1){
                selection = 0
            }else{
                selection += 1
            }
            
        }
        timer.fire()
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
