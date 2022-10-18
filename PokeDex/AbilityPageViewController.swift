//
//  AbilityPageViewController.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 16.10.2022.
//

import UIKit
import SDWebImage

class AbilityPageViewController: UIViewController
{

    @IBOutlet weak var pokemonIMG: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBOutlet weak var abilityOneTitle: UILabel!
    @IBOutlet weak var abilityOneDesc: UILabel!
    
    @IBOutlet weak var abilityTwoTitle: UILabel!
    @IBOutlet weak var abilityTowDesc: UILabel!
    
    var getIMGURL = ""
    var getName = ""
    var getURL = ""

    var getDataNameAbilities = [String]()
    var getDataAbilitesURL = [String]()
    var getDataAbilitiesDesc = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pokemonIMG.sd_setImage(with: URL(string: getIMGURL))
        pokemonName.text = getName.capitalized
        
        getData()
    }
    
    func getData()
    {
        let apiURL = URL(string: getURL)
        let session = URLSession.shared
        let task = session.dataTask(with: apiURL!) { data, response, error in
            if(data != nil)
            {
                do
                {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    let pokeee = try JSONDecoder().decode(Pokemon.self, from: Data((jsonStr?.utf8)!))
                    pokeee.abilities.map({ Ability in
                        self.getDataNameAbilities.append(Ability.ability.name)
                        self.getDataAbilitesURL.append(Ability.ability.url)
                        DispatchQueue.main.async
                        {
                            self.abilityOneTitle.text = self.getDataNameAbilities[0].capitalized
                            if(self.getDataNameAbilities.count > 1)
                            {
                                self.abilityTwoTitle.text = self.getDataNameAbilities[1].capitalized
                            }
                            self.getPokemonDec(url: Ability.ability.url)
                        }
                    })
                }
                catch
                {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func getPokemonDec(url : String)
    {
        let apiURLNew = URL(string: url)
        let session = URLSession.shared
        let task = session.dataTask(with: apiURLNew!) { data, response, error in
            if(data != nil)
            {
                do
                {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    let pokeDesc = try JSONDecoder().decode(SkillDescription.self, from: Data((jsonStr?.utf8)!))
                    pokeDesc.effect_entries.map { Skill in
                        self.getDataAbilitiesDesc.append(Skill.short_effect)
                    }
                    DispatchQueue.main.async
                    {
                        if(self.getDataAbilitiesDesc.count > 2)
                        {
                            self.abilityOneDesc.text = self.getDataAbilitiesDesc[1] + "\n-----" + "\n\(self.getDataAbilitiesDesc[0])"
                            self.abilityTowDesc.text = self.getDataAbilitiesDesc[3] + "\n-----" + "\n\(self.getDataAbilitiesDesc[2])"
                        }
                        else
                        {
                            self.abilityOneDesc.text = self.getDataAbilitiesDesc[0]
                        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "statPage")
        {
            let destinationVC = segue.destination as! StatsPageViewController
            destinationVC.stats_NamePokemon = getName.capitalized
            destinationVC.stats_IMGPokemon = getIMGURL
            destinationVC.stats_PokemonURL = getURL
        }
    }
    
    @IBAction func statsPageCliked(_ sender: Any) {
        
        performSegue(withIdentifier: "statPage", sender: nil)
    }
    

}
