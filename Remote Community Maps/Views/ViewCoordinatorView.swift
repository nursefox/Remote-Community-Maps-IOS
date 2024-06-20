//
//  ViewCoordinatorView.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 20/6/2024.
//

import SwiftUI

struct ViewCoordinatorView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            ContentView()
        }else {
            SplashScreenView(isActive: $isActive)
        }
    }
}

#Preview {
    ViewCoordinatorView()
}
