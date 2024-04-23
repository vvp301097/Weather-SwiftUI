//
//  SearchView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 17/04/2024.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                navigationBar()
                    .padding(.horizontal, 16)
                
                CustomSearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                ScrollView(showsIndicators: false) {
                    
                    
                    
                    ForEach(0..<10) { i in
                        WeatherView()
                            .padding(.bottom, 20)
                    }
                }
            }
//            .ignoresSafeArea(.all, edges: .bottom)
            .background(LinearGradient(colors: [Color(hex: "2E335A"), Color(hex: "1C1B33")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    
            .navigationBarTitle("")
            .navigationBarHidden(true)


        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()

                    .frame(width: 18, height: 24)
                    .foregroundColor(Color(hex: "EBEBF5").opacity(0.6))
            }

            Text("Weather")
                .font(.system(size: 28))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
