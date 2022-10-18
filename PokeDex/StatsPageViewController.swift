//
//  StatsPageViewController.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 16.10.2022.
//

import UIKit
import SDWebImage

class StatsPageViewController: UIViewController {

    @IBOutlet weak var pokemonIMG: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    
    @IBOutlet weak var pokemonHP: UILabel!
    @IBOutlet weak var pokemonAttack: UILabel!
    @IBOutlet weak var pokemonDefense: UILabel!
    @IBOutlet weak var pokemonSpecialAttack: UILabel!
    @IBOutlet weak var pokemonSpecialDefense: UILabel!
    @IBOutlet weak var pokemonSpeed: UILabel!
    
    var stats_NamePokemon = ""
    var stats_IMGPokemon = ""
    var stats_PokemonURL = ""
    
    var statsNameArray = [String]()
    var statsValueArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokemonName.text = stats_NamePokemon.capitalized
        pokemonIMG.sd_setImage(with: URL(string: stats_IMGPokemon))
        
        getData()
    }
    
    func getData()
    {
        let apiURLNew = URL(string: stats_PokemonURL)
        let session = URLSession.shared
        let task = session.dataTask(with: apiURLNew!) { data, response, error in
            if(data != nil)
            {
                do
                {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    let pokeStats = try JSONDecoder().decode(BaseStat.self, from: Data((jsonStr?.utf8)!))
                    pokeStats.stats.map { PokemonStat in
                        self.statsNameArray.append(PokemonStat.stat.name)
                    }
                    
                    let pokeValue = try JSONDecoder().decode(StatsValue.self, from: Data((jsonStr?.utf8)!))
                    pokeValue.stats.map { PokemonStatValue in
                        self.statsValueArray.append(PokemonStatValue.base_stat)
                        DispatchQueue.main.async
                        {
                            if(self.statsNameArray.count > 2)
                            {
                                self.pokemonHP.text = self.statsNameArray[0].capitalized + ": \(self.statsValueArray[0])"
                                self.pokemonAttack.text = self.statsNameArray[1].capitalized + ": \(self.statsValueArray[1])"
                                self.pokemonDefense.text = self.statsNameArray[2].capitalized + ": \(self.statsValueArray[2])"
                                self.pokemonSpecialAttack.text = self.statsNameArray[3].capitalized + ": \(self.statsValueArray[3])"
                                self.pokemonSpecialDefense.text = self.statsNameArray[4].capitalized + ": \(self.statsValueArray[4])"
                                self.pokemonSpeed.text = self.statsNameArray[5].capitalized + ": \(self.statsValueArray[5])"
                            }
                        }
                    }
                    
                    let pokeHeightValue = try JSONDecoder().decode(HValue.self, from: Data((jsonStr?.utf8)!))
                    
                    DispatchQueue.main.async
                    {
                        self.pokemonHeight.text = "Height : \(pokeHeightValue.height)"
                    }
                    
                    
                    let pokeWeightValue = try JSONDecoder().decode(WValue.self, from: Data((jsonStr?.utf8)!))
                    DispatchQueue.main.async
                    {
                        self.pokemonWeight.text = "Weight : \(pokeWeightValue.weight)"
                    }
                }
                catch
                {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    
    func makeAlert(title : String , message : String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okeyButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okeyButton)
        self.present(alert, animated: true, completion: nil)
    }
}
