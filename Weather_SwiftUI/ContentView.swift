//
//  ContentView.swift
//  Weather_SwiftUI
//
//  Created by Phat on 13/04/2024.
//

import SwiftUI
enum Page {
    case home
    case setting
}
struct ContentView: View {
    
    @State var currentTab = Page.home
    @State var goToSearch = false

    var body: some View {
        NavigationView {

        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab){
                    HomeView()
                        .tag(Page.home)
              
                SettingView()
                    .tag(Page.setting)
                
            }
            .frame(maxWidth: .infinity)
            
            CustomTabview(currentTabItem: $currentTab) {
                print("aagga")
                goToSearch = true
            }
            
            NavigationLink(isActive: $goToSearch) {
                SearchView()
                    .navigationBarTitle("") //this must be empty
                    .navigationBarHidden(true)
            } label: {
                EmptyView()
            }
        }
        .ignoresSafeArea()
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
