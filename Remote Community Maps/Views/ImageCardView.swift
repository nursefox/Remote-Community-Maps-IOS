//
//  ImageCardView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 3/1/2024.
//

import SwiftUI

struct ImageCardView: View {
    
    let imageName: String
    let communityName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
            cardText.padding(.horizontal, 8)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24.0))
        .shadow(radius: 8)
    }
    
    var cardText: some View {
        VStack(alignment: .center) {
            Text (communityName)
                .font(.subheadline)
            HStack (spacing: 4.0) {
              //Text ("Something")
            }
        }.foregroundColor(.gray)
        .padding(.bottom, 16)
    }
}

#Preview {
    HStack (spacing: 20) {
        ImageCardView(imageName: "Santa-Teresa-Profile-Photo", communityName: "Santa Teresa")
        
        ImageCardView(imageName: "Hermannsburg-NT", communityName: "Hermannsburg")
    }
}
