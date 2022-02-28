//
//  LandingView.swift
//  FurryFriends
//
//  Created by Luke Newbigging on 2022-02-28.
//

import SwiftUI
import ACarousel

struct Item: Identifiable {
    let id = UUID()
    let image: Image
}

let roles = ["CatPic1", "CatPic2", "CatPic3", "DogPic1", "DogPic2", "DogPic3"]

struct LandingView: View {
    
    let items: [Item] = roles.map { Item(image: Image($0)) }
    
    var body: some View {
        VStack (spacing: 10) {
            
            Text("Furry Friends")
                .bold()
                .font(.largeTitle)
            
            Divider()
            Text("Look at these cute animals!")
                .font(.subheadline)
                .bold()
                .padding(10)
            
            HStack{
                ACarousel(items) { item in
                    item.image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .cornerRadius(30)
                }
                .frame(height: 300)
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
