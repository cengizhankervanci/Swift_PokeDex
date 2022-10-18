//
//  ViewController.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 13.10.2022.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemonClass = [PokemonDatas]()
    
    var getDataNameArray = [String]()
    var getDataInfoUrlArray = [String]()
    var getDataAllImgUrlArray = [String]()
    var index = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    var currentPokemonArray = [PokemonDatas]()
    
    //Selection
    var selectedName = ""
    var selectedURL = ""
    var selectedIMG = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        searchBar.delegate = self
        
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPokemonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableView", for: indexPath) as! CustomTableCell

        cell.pokemonName.text = currentPokemonArray[indexPath.row].pokemonName.capitalized
        cell.pokemonImageView.sd_setImage(with: URL(string: currentPokemonArray[indexPath.row].pokemonImageURL))
        cell.pokemonDetailURL.text = currentPokemonArray[indexPath.row].pokemonInfoURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedName = currentPokemonArray[indexPath.row].pokemonName
        selectedURL = currentPokemonArray[indexPath.row].pokemonInfoURL
        selectedIMG = currentPokemonArray[indexPath.row].pokemonImageURL
        performSegue(withIdentifier: "detailPage", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailPage")
        {
            let destinationVC = segue.destination as! AbilityPageViewController
            destinationVC.getName = selectedName.capitalized
            destinationVC.getIMGURL = selectedIMG
            destinationVC.getURL = selectedURL
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //SEARCH
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        guard !searchText.isEmpty else{
            currentPokemonArray = pokemonClass
            tableView.reloadData()
            return
        }
        currentPokemonArray = pokemonClass.filter({ pokemonClass in
            pokemonClass.pokemonName.contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    //
    
    func createPokemonObject(name : String , info : String , url: String)
    {
        pokemonClass.append(PokemonDatas(pokemonName: name, pokemonInfoURL: info, pokemonImageURL: url))
    }
    
    func getData()
    {
        let apiURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0")
        let session = URLSession.shared
        let task = session.dataTask(with: apiURL!) { data, response, error in
            if(data != nil)
            {
                do
                {
                    let jsonString = String(data: data!, encoding: .utf8)
                    let pokemonInfo = try JSONDecoder().decode(PokemonFirstApi.self, from: Data((jsonString?.utf8)!))
                    pokemonInfo.results.map { PokemonNameUrl in
                        DispatchQueue.main.async
                        {
                            self.getDataNameArray.append(PokemonNameUrl.name)
                            self.getDataInfoUrlArray.append(PokemonNameUrl.url)
                            self.getimageURL(url: self.getDataInfoUrlArray[self.index], index: self.index)
                            self.index += 1
                            self.tableView.reloadData()
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
    
    func getimageURL(url : String , index : Int)
    {
        let apiURL = URL(string: url)
        let session = URLSession.shared
        let task = session.dataTask(with: apiURL!) { data, response, error in
            if(data != nil)
            {
                do
                {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    DispatchQueue.main.async
                    {
                        if let pokemonDic = jsonResponse["sprites"] as? [String:Any]
                        {
                            if let imageURL = pokemonDic["front_default"]
                            {
                                let testArray = [imageURL as? String ?? "pokemonicon"]
                                self.createPokemonObject(name: self.getDataNameArray[index], info: self.getDataInfoUrlArray[index],url:testArray[0])
                            }
                            self.currentPokemonArray = self.pokemonClass
                            self.tableView.reloadData()
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
}
