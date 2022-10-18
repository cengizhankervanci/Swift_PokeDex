//
//  PokemonDatas.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 13.10.2022.
//

import Foundation

class PokemonDatas
{
    var pokemonName : String
    var pokemonInfoURL : String
    var pokemonImageURL : String
    
    init(pokemonName: String, pokemonInfoURL: String, pokemonImageURL: String) {
        self.pokemonName = pokemonName
        self.pokemonInfoURL = pokemonInfoURL
        self.pokemonImageURL = pokemonImageURL
    }
}
