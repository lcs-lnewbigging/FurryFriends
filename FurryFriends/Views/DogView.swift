//
//  DogView.swift
//  FurryFriends
//
//  Created by Luke Newbigging on 2022-02-28.
//

import SwiftUI

struct DogView: View {
    
    // MARK: Stored properties
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var currentDog: Dog = Dog(message: "",
                                     status: "")
    
    
    @State var favourites: [Dog] = []
    
    
    @State var currentDogAddedToFavourites: Bool = false
    
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    // MARK: Computed properties
    var body: some View {
        VStack {
            Text("Dogs")
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
                .foregroundColor(currentDogAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    
                    if currentDogAddedToFavourites == false {
                        
                        
                        favourites.append(currentDog)
                        
                        
                        currentDogAddedToFavourites = true
                        
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
                    await loadNewDog()
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
            
            
            List(favourites, id: \.self) { currentFavourite in
                let currentFavouriteURL = URL(string: currentFavourite.message)!
                RemoteImageView(fromURL: currentFavouriteURL)
                //                Text(currentFavourite.message)
            }
            
            Spacer()
            
        }
        
        .task {
            
            // Load a dog from the endpoint!
            // We "calling" or "invoking" the function
            // named "loadDog"
            // A term for this is the "call site" of a function
            // What does "await" mean?
            // This just means that we, as the programmer, are aware
            // that this function is asynchronous.
            // Result might come right away, or, take some time to complete.
            // ALSO: Any code below this call will run before the function call completes.
            await loadNewDog()
            
            
            print("I tried to load a new dog")
            
            loadFavourites()
        }
        
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .inactive{
                print("Inactive")
            } else if newPhase == .active {
                print ("Active")
            } else if newPhase == .background{
                print ("background")
                
                //permantly save the list of tasks
                persistFavourites()
                
                
            }
            
        }
        
        .background(Color.cyan)
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.cyan)
        
    }
    
    // MARK: Functions
    
    
    func loadNewDog() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentDog"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentDog = try JSONDecoder().decode(Dog.self, from: data)
            
            currentImage = URL(string: currentDog.message)!
            
            
            // Reset the flag that tracks whether the current joke
            // is a favourite
            currentDogAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
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
            
            
            
            favourites = try JSONDecoder().decode([Dog].self, from: data)
            
            
            
            
        } catch {
            
            print("Could not load the data from the stored JSON file")
            print("=======")
            print(error.localizedDescription)
        }
    }
}



struct DogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DogView()
        }
        .preferredColorScheme(.light)
    }
}
