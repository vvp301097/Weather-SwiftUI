//
//  View+Ext.swift
//  Weather_SwiftUI
//
//  Created by Phat on 15/04/2024.
//
import SwiftUI
import UIKit
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
