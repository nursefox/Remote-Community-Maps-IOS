//
//  CommunityMapsHomeScreenView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 20/6/2024.
//

import SwiftUI

struct CommunityMapsHomeScreenView: View {
    
    @State private var isSplashScreenActive = true
    
    var body: some View {
        ContentView()
//            .splashScreen(isActive: $isSplashScreenActive, animation: .wiggle,
//                          animationValue: 10) {
//                 Image(systemName: "applelogo")
//                     .font(.system(size: 100))
//                     .foregroundColor(.white)
//             } background: {
//                 Color.blue
//             }
        
            .splashScreen(isActive: $isSplashScreenActive, animation: .scale,
                          animationValue: 1.05) {
                 //                 Image(systemName: "applelogo")
                 //                     .font(.system(size: 100))
                 //                     .foregroundColor(.white)

                VStack {
                    HStack {
                        Image("RCMIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 250, maxHeight: 250)
                    }
                    
                    
                    Text("Remote Community Maps")
                        .font(.system(size: 20))
                
                    
                }
                 
              } background: {
                  Color.white
              }
              
        
        
//        Image("RCMIcon")
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(minHeight: 100, maxHeight: 100)
        
        
//            .overlay {
//                SplashScreen(isActive: $isSplashScreenActive, animation: .wiggle,
//                             animationValue: 10) {
//                    Image(systemName: "applelogo")
//                        .font(.system(size: 100))
//                        .foregroundColor(.white)
//                } background: {
//                    Color.blue
//                }
//            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isSplashScreenActive.toggle()
                }
            }
    }
}

#Preview {
    CommunityMapsHomeScreenView()
}
