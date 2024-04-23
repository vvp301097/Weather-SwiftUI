//
//  CustomSearchBar.swift
//  Weather_SwiftUI
//
//  Created by Phat on 17/04/2024.
//

import SwiftUI

struct CustomSearchBar: View {
    
    @Binding var text: String
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
            TextField("", text: $text)
                .placeholder(when: text.isEmpty) {
                        Text("Search for a city or airport").foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
                }
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(colors: [Color(hex: "2E335A"), Color(hex: "1C1B33")], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "000000").opacity(0.25))
                .shadow(color: Color(hex: "000000").opacity(1),radius: 4, x: 4, y: 4)
                .shadow(color: Color(hex: "000000").opacity(1),radius: 4, x: -4, y: -4)
                .clipShape(            RoundedRectangle(cornerRadius: 10)
                          )
        )
            
        
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(text: .constant(""))
    }
}
