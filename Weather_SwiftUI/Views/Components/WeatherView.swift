//
//  WeatherView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 17/04/2024.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        HStack(alignment: .bottom ,spacing: 8) {
            VStack(alignment: .leading, spacing: 24) {
                Text("19°")
                    .font(.system(size: 64, weight: .regular))
                    .foregroundColor(.white)
                    .frame(height: 41)
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("H:24° L:18°")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
                        .frame(height: 20)
                    Text("Montreal, Canada")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .frame(height: 28)
                    
                }
            }
            
            VStack(alignment: .trailing, spacing: 0) {
                Image("ic_moon_cloud_fast_wind")
                    .resizable()
                    .frame(width: 160, height: 160)
                Text("Mid Rain")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white)
                    .frame(height: 18)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(height: 184)
        .background(WeatherBackgroundShape().fill(.linearGradient(colors: [Color(hex: "5936B4"), Color(hex: "362A84")], startPoint: .leading, endPoint: .trailing)))

    }
}

struct WeatherBackgroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 30))
            path.addQuadCurve(to: CGPoint(x: rect.minX + 20, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 30), control: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 30,y: rect.midY - 30), control: CGPoint(x: rect.maxX, y: rect.midY - 20))
            path.addLine(to: CGPoint(x: rect.minX + 30, y: rect.minY))
            
            path.addQuadCurve(to: CGPoint(x: rect.minX,y: rect.minY + 30), control: CGPoint(x: rect.minX, y: rect.minY))
            

        }
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
