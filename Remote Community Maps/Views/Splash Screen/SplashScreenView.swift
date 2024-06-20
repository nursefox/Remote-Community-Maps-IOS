//
//  SplashScreenView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 20/6/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.7
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            VStack {
                
                Image("RCMIcon")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(minHeight: 100, maxHeight: 100)
                
//                Image("foxtrails-logo-large")
//                    .font(.system(size: 100))
//                    .foregroundColor(.blue)
                
                Text("Remote Community Maps")
                    .font(.system(size: 20))
            }.scaleEffect(scale)
                .onAppear{
                    withAnimation(.easeIn(duration: 0.7)) {
                        self.scale = 0.9
                    }
                }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

//#Preview {
//    SplashScreenView(isActive: .constant(true))
//}


