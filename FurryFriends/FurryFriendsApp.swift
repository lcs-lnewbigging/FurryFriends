//
//  FurryFriendsApp.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

@main
struct FurryFriendsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView{
                    LandingView()
                        .tabItem {
                            Label("Home Page", systemImage: "house.fill")
                        }
                    ContentView()
                        .tabItem {
                            Label("Cats!", systemImage: "house.fill")
                        }
                    DogView()
                        .tabItem {
                            Label("Dogs!", systemImage: "house.fill")
                        }
                
                
                
                
                
                }
            
            
            
            
            
            
            
            
            
            
            
            }
        }
    }
}
