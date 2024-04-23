//
//  TabvView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 14/04/2024.
//

import SwiftUI



struct CustomTabview: View {
    
    @Binding var currentTabItem: Page
    var didSelectAddButton: () -> ()
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                Button {
                    currentTabItem = .home
                } label: {
                    Image("ic_current")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
                Spacer()
                
                Button {
                    currentTabItem = .setting
                } label: {
                    Image("ic_more")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .padding(.horizontal, 32)
            .padding(.top, 20)
            .padding(.bottom, 24)
            .background(
                ZStack {
                    CurveTopShape()
                        .fill(LinearGradient(colors: [Color(hex: "3A3A6A"), Color(hex: "25244C")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    CurveTopShape()
                        .stroke(Color(hex: "7582F4").opacity(0.5), lineWidth: 0.5)
                }
            )
            Button {
                didSelectAddButton()
//                SearchView()

            } label: {
                    Image("ic_plus")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .background(
                            Circle().stroke(lineWidth: 5.8).fill(LinearGradient(colors: [Color(hex: "FFFFFF").opacity(0),Color(hex: "FAFAFB").opacity(0.75), Color(hex: "BBBFC7")], startPoint: .topLeading, endPoint: .bottom))
                                .frame(width: 58, height: 58)
                                .blur(radius: 2)
                                .mask({
                                    Circle()
                                        .fill(LinearGradient(colors: [Color(hex: "F5F5F9"), Color(hex: "DADFE7")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 58, height: 58)
                                })
                            
                        )
                        
                        .background(
                            ZStack{
                                Circle().stroke(LinearGradient(colors: [Color(hex: "FFFFFF"), Color(hex: "AEAEAE")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.2)
                                Circle().fill(
                                    LinearGradient(colors: [Color(hex: "F5F5F9"), Color(hex: "DADFE7")], startPoint: .topLeading, endPoint: .bottomTrailing)

                                )

                            }
                                .frame(width: 58, height: 58)
                                
                        )
                        .background(
                            Circle()
//                                .stroke(lineWidth: 4)
                                .fill(.linearGradient(colors: [Color(hex: "000000"), .init(hex: "FFFFFF").opacity(0.76)], startPoint: .topLeading, endPoint: .bottomTrailing))

                                .frame(width: 64, height: 64)
                                .blur(radius: 1)
                        )
                        .background(
                            Circle().stroke(LinearGradient(colors: [Color(hex: "FFFFFF"), Color(hex: "AEAEAE")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.2)
                        )

            }
            

            .shadow(color: Color(hex: "0D1431").opacity(0.3), radius: 5, x: 5, y: 5)
            .shadow(color: Color(hex: "FFFFFF").opacity(0.3), radius: 5
                    , x: -5, y: -5)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .frame(width: 258, height: 100)
            .background(ZStack {
                
                AddButtonShape()
                    .fill(LinearGradient(colors: [Color(hex: "262C51"), Color(hex: "3E3F74")], startPoint: .topTrailing, endPoint: .bottomTrailing))

                AddButtonShape()
                    .stroke(Color(hex: "7582F4").opacity(0.5), lineWidth: 0.5)
                   
            }

                                    
                            
            )
        }
    }
}

struct CustomTabview_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabview(currentTabItem: .constant(.home)) {
            
        }
    }
}


struct CurveTopShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            //Top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.maxY * 0.5))
        }
        
    }
}

struct AddButtonShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            //Top left
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addCurve(to: CGPoint(x: rect.midX - 15, y: rect.minY), control1: CGPoint(x: rect.midX * 0.5, y: rect.maxY), control2: CGPoint(x: rect.midX * 0.5 , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + 15, y: rect.minY))
            path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control1: CGPoint(x: rect.midX * 1.5 , y: rect.minY), control2: CGPoint(x: rect.midX * 1.5, y: rect.maxY))
        }
        
    }
}
