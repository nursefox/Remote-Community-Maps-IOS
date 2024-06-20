//
//  View+.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 20/6/2024.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func `if` <Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
