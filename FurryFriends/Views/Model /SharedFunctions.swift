//
//  SharedFunctions.swift
//  FurryFriends
//
//  Created by Luke Newbigging on 2022-03-01.
//

import Foundation

// The DadJoke structure conforms to the
// Decodable protocol. This means that we want
// Swift to be able to take a JSON object
// and 'decode' into an instance of this
// structure
struct FurryFriends: Decodable, Hashable, Encodable {
    
    let message: String
    
    let status: String
}
