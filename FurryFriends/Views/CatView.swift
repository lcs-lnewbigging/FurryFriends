//
//  CatView.swift
//  FurryFriends
//
//  Created by Luke Newbigging on 2022-03-02.
//

import SwiftUI

struct CatView: View {
    
    // MARK: Stored properties
    // Detect when an app moves between forground, background, and inactive states
    @Environment(\.scenePhase) var scenePhase
    
    @State var currentCat: Cat = Cat(file: "")
    
    // This will keep track of our list of favourite jokes
    @State var favourites: [Cat] = []   // empty list to start
    
    // This will let us know whether the current exists as a favourite
    @State var currentCatAddedToFavourites: Bool = false
    
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    // MARK: Computed properties
    var body: some View {
        VStack {
            Text("Cats")
                .bold()
                .font(.largeTitle)
            RemoteImageView(fromURL: currentImage)
                .font(.title)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                )
                .padding(10)
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
            //                      CONDITION                        true   false
                .foregroundColor(currentCatAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentCatAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentCat)
                        
                        // Record that we have marked this as a favourite
                        currentCatAddedToFavourites = true
                        
                    }
                    
                }
            
            Button(action: {
                
                // The Task type allows us to run asynchronous code
                // within a button and have the user interface be updated
                // when the data is ready.
                // Since it is asynchronous, other tasks can run while
                // we wait for the data to come back from the web server.
                Task {
                    // Call the function that will get us a new joke!
                    await loadNewCat()
                }
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.borderedProminent)
            
            HStack {
                Text("Favourites")
                    .bold()
                
                Spacer()
            }
            
            // Iterate over the list of favourites
            // As we iterate, each individual favourite is
            // accessible via "currentFavourite"
            List(favourites, id: \.self) { currentFavourite in
                let currentFavouriteURL = URL(string: currentFavourite.file)!
                RemoteImageView(fromURL: currentFavouriteURL)
                //                Text(currentFavourite.message)
            }
            
            Spacer()
            
        }
        
        .task {
            
            await loadNewCat()
            
            
            print("I tried to load a new cat")
            
            loadFavourites()
        }
        
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .inactive{
                print("Inactive")
            } else if newPhase == .active {
                print ("Active")
            } else if newPhase == .background{
                print ("background")
                
                
                persistFavourites()
                
                
            }
            
        }
        //        .navigationTitle("Cats")
        .padding(10)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.cyan)
        
    }
    
    // MARK: Functions
    
    func loadNewCat() async {
        
        let url = URL(string: "https://aws.random.cat/meow")!
        
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        
        let urlSession = URLSession.shared
        
        
        do {
            
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentCat"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentCat = try JSONDecoder().decode(Cat.self, from: data)
            
            currentImage = URL(string: currentCat.file)!
            
            
            
            currentCatAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            
            print(error)
        }
        
    }
    
    func persistFavourites() {
        
        let fileName = getDocumentsDirectory() .appendingPathComponent(saveFavouritesLabel)
        print(fileName)
        
        
        
        do{
            
            let encoder = JSONEncoder()
            
            
            encoder.outputFormatting = .prettyPrinted
            
            
            let data = try encoder.encode(favourites)
            
            
            try data.write(to: fileName, options: [ .atomicWrite, .completeFileProtection])
            
            
            print ("Saved data to the Document Directory sucessfully")
            print ("=========")
            print (String(data: data, encoding: .utf8)!)
            
        } catch {
            print (" Unable to write to the Documents Directory")
            print("=========")
            print(error.localizedDescription)
        }
        
    }
    
    
    func loadFavourites() {
        
        let fileName = getDocumentsDirectory() .appendingPathComponent(saveFavouritesLabel)
        print(fileName)
        
        
        
        do{
            
            
            
            let data = try Data (contentsOf: fileName)
            
            
            print ("Saved data to the Document Directory sucessfully")
            print ("=========")
            print (String(data: data, encoding: .utf8)!)
            
            
            
            favourites = try JSONDecoder().decode([Cat].self, from: data)
            
            
            
            
        } catch {
            //What went wrong
            print("Could not load the data from the stored JSON file")
            print("=======")
            print(error.localizedDescription)
        }
    }
}




struct CatView_Previews: PreviewProvider {
    static var previews: some View {
        CatView()
    }
}
