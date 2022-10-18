//
//  PokemonSkillFromApi.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 16.10.2022.
//

import Foundation

struct SkillDesc : Codable {
    let short_effect: String
}

struct SkillDescription: Decodable {
    let effect_entries: [SkillDesc]
}
