//
//  HomeView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 14/04/2024.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @State var isHourly: Bool = true
    
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                
                infoView()
                
                
                Image("image_house").resizable().scaledToFit()
                    .padding(.bottom, 50)
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .background(Image("background")
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            GeometryReader { proxy in
                Rectangle()
                    .fill(.linearGradient(colors: [Color(hex: "3A3F54").opacity(0), Color(hex: "3A3F54")], startPoint: .top, endPoint: .bottom))
                    .frame(height: proxy.size.height / 2)
                    .offset(y: proxy.size.height / 2)
            }
            
            .ignoresSafeArea()
            
            sheetView()
        }
        
        .ignoresSafeArea()
        .onAppear {
            viewModel.getCurrentWeather()
        }
    }
    
    @ViewBuilder
    func infoView() -> some View {
        let weather = viewModel.weather
        VStack(spacing: 12) {
            Text(viewModel.location?.name ?? "N/a")
                .font(.system(size: 34, weight: .regular))
                .foregroundColor(.white)
                .frame(height: 41)
            
            Text((weather != nil ? "\(Int( weather!.temperature.value))" : "N/a") + "°" )
                .font(.system(size: 96, weight: .thin))
                .foregroundColor(.white)
                .frame(height: 70)
            VStack(spacing: 8) {
                Text(weather?.weatherText ?? "")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
                    .frame(height: 20)
                if weather != nil {
                    Text("H:\(Int( weather!.maxTemperature.value ))°   L:\( Int(weather!.minTemperature.value))°")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 20)
                }
                
            }
            
        }
    }
    
    @ViewBuilder
    func sheetView() -> some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            if let weather = viewModel.weather {
                
            
            VStack(alignment: .center ,spacing: 0) {
                HStack {
                    Button {
                        isHourly = true
                    } label: {
                        Text("Hourly Forecast")
                            .overlay(
                                Rectangle()
                                    .fill(.linearGradient(colors: [.white.opacity(0), .white.opacity(0.75), .white.opacity(0)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 2)
                                    .offset(y: 3)
                                    .opacity(isHourly ? 1 : 0)
                                ,
                                alignment: .bottom
                            )
                    }
                    
                    Spacer()
                    Button {
                        isHourly = false

                    } label: {
                        Text("Week Forecast")
                            .overlay(
                                Rectangle()
                                    .fill(.linearGradient(colors: [.white.opacity(0), .white.opacity(0.75), .white.opacity(0)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 2)
                                    .offset(y: 3)
                                    .opacity(isHourly ? 0 : 1)

                                     ,
                                     alignment: .bottom
                            )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 5)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
                .overlay(
                    Capsule()
                        .fill(.black.opacity(0.3))
                        .frame(width: 48, height: 5)
                        
                        .padding(.top, 10)
                        
                    ,alignment: .top
                )
                .background(
                    ZStack(alignment: .top) {
                        Ellipse()
                            .fill(Color(hex: "C427FB").opacity(0.5))
                            .offset(y: -25)
                            .frame(width: proxy.size.width - 96, height: 32)
                            .clipped()
                            .blur(radius: 15)

                        Ellipse()
                            .foregroundColor(Color(hex: "E0D9FF"))
                            .offset(y: -5)
                            .frame(width: proxy.size.width - 96, height: 10)
                            .clipped()
                            .blur(radius: 10)

                    }
                    ,alignment: .top

                )
                .background(Rectangle().fill(.white.opacity(0.3)).frame(height: 1)
                                .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
                            , alignment: .bottom)
                if isHourly {
                    ScrollView(.horizontal, showsIndicators: false) {
                        let items = viewModel.getDataForHourly(hourlys: weather.hourlyWeather, weather: weather)
                        HStack(spacing: 12) {
                            ForEach(items, id: \.self) { item in
                                HourlyView(data: item)
                            }
                        }
                        .padding(20)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 12) {
                            ForEach(0..<6) { _ in
//                                HourlyView(isActive: .constant(false))
                            }
                        }
                        .padding(20)
                    }
                }
                    
                    
                
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 110)
            .background(
                RoundedRectangle(cornerRadius: 44)
                    .fill(.linearGradient(colors: [.init(hex: "2E335A"), .init(hex: "1C1B33")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .opacity(0.26)
                    .shadow(color: .white, radius: 0, x: 0, y: -1)
                    .background(
                        BlurView(style: .systemUltraThinMaterialDark)
                            .clipShape(RoundedRectangle(cornerRadius: 44))
//                            .ultraThinMaterial,in:
//                            RoundedRectangle(cornerRadius: 44)
                    )
                
            )
            .offset(y:height - 350)
            } else {
                ProgressView()
            }
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
