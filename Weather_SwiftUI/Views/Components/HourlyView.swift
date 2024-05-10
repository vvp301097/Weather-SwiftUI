//
//  HourlyView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 17/04/2024.
//

import SwiftUI

struct TileWeather: Hashable {
    let topText: String
    let icon: String
    let posibleRain: String
    let temperature: String
    var isActive: Bool = false
}

struct HourlyView: View {
    
    
    var data: TileWeather
    
    var body: some View {
        VStack(spacing: 16) {
            Text(data.topText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 20)
            
            VStack(spacing: 0) {
                Image(data.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                Text(!data.posibleRain.isEmpty ? "\(data.posibleRain)%" : "")
                    .font(.system(size: 13, weight: .semibold))
                    .frame(height: 18)
                    .foregroundColor(Color(hex: "40CBD8"))
            }
            Text("\(data.temperature)°")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
                .frame(height: 24)
        }
        .frame(width: 60)

//        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30).fill(Color(hex: "48319D").opacity(data.isActive ? 1 : 0.2))
                RoundedRectangle(cornerRadius: 30).strokeBorder(Color(hex: "FFFFFF").opacity(0.2), lineWidth: 1)
            }
                .shadow(color: .white.opacity(0.25), radius: 0, x: 1, y: 1)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
            
        )
        
        
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView(data: .init(topText: "12AM", icon: "", posibleRain: "", temperature: ""))
        
    }
}
