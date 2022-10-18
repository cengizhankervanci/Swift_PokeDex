//
//  GetApiFromAbilities.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 16.10.2022.
//

import Foundation

struct AbilityNameValue : Codable {
    let name: String
    let url: String
}

struct Ability: Codable {
    let ability: AbilityNameValue
}

struct Pokemon: Decodable {
    let abilities: [Ability]
}
