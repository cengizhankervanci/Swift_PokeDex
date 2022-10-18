//
//  PokemonBaseValueFromApi.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 17.10.2022.
//

import Foundation

struct PokemonBase : Codable
{
    let name : String
    let url : String
}

struct PokemonStat : Codable
{
    let stat : PokemonBase
}

struct BaseStat : Decodable
{
    let stats : [PokemonStat]
}


struct PokemonBase_Stat : Codable
{
    let base_stat : Int
}

struct StatsValue : Decodable
{
    let stats : [PokemonBase_Stat]
}


struct HValue : Decodable
{
    let height : Int
}

struct WValue : Decodable
{
    let weight : Int
}

struct PokemonNameUrl : Codable
{
    let name : String
    let url : String
}

struct PokemonFirstApi : Decodable
{
    let results : [PokemonNameUrl]
}

struct PokemonIMGValuee : Codable
{
    let front_default : String
}

struct PokemonIMGNew : Decodable
{
    let sprites : PokemonIMGValuee
}

