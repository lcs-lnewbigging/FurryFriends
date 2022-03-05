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
        ScrollView{
            VStack (spacing: 10) {
                
                Text("Furry Friends")
                    .bold()
                    .font(.largeTitle)
                
                Spacer()
                
                
                Text("Look at these cute animals!")
                    .font(.body)
                    .bold()
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 4)
                    )
                
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
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                        .padding(-5)
                )
                .padding(10)
                
                
                HStack{
                    Text("Check out some of the other tabs to see pictures of cats and dogs!")
                        .bold()
                        .font(.body)
                        .padding()
                    //                        .background(Color.cyan)
                    
                    
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                )
                .padding(10)
//                List{
//                    NavigationLink( destination:DogView())
//                }
                Spacer()
                
                
                
                
            }
            NavigationLink(destination: DogView()) {
                
                EnhancedListItemView(imageName: "DogPic1",
                                     title: "Your Favourite Dogs",
                                     subtitle: "Check out your favourited dog images!")
                    .font(.body)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4)
                    .padding(-10)
            )
            .padding(25)
            NavigationLink(destination: CatView()) {
                
                EnhancedListItemView(imageName: "CatPic1",
                                     title: "Your Favourite Cats",
                                     subtitle: "Check out your favourited cat images!")
                    .font(.body)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4)
                    .padding(-10)
            )
        
        
        
        
        
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.cyan)
    }
    
}


struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
        LandingView()
            .preferredColorScheme(.dark)
        }
    }
}
