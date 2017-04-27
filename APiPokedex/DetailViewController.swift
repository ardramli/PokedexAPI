//
//  DetailViewController.swift
//  APiPokedex
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    
    var selectedPokemon : Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedPokemon == nil {
            return
        }
        
        nameLabel.text = selectedPokemon.name
        getPokemonDetails()
    }
    
    func getPokemonDetails() {
        //1. get url
        //let urlString = selectedPokemon.url
        guard let url = URL(string: selectedPokemon.url)
            else {return}
        //2. session
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                print("Error \(err.localizedDescription)" )
                return
            }
            guard let data = data
                else {
                    print ("Data error")
                    return
            }
            print(data)
            
            if let dictData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                //get type
                var typeString = ""
                
                if let typesDict = dictData?["types"] as? [[String : Any]] {
                    for typeDict in typesDict {
                        if let type = typeDict["type"] as? [String:String] {
                           if let typeName = type["name"] {
                                typeString = typeString + ", " + typeName
                                typeString.remove(at: typeString.startIndex)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.typeLabel.text = typeString
                }
                //get ability
                var abilityString = ""
                
                if let abilitiesDict = dictData?["abilities"] as? [[String: Any]] {
                    for abilityDict in abilitiesDict {
                        if let ability = abilityDict["ability"] as? [String:String] {
                            if let abilityName = ability["name"]{
                                abilityString = abilityString + ", " + abilityName
                                abilityString.remove(at: abilityString.startIndex)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.abilityLabel.text = abilityString
                }
                //get image
                
                if let imageDict = dictData?["sprites"] as? [String: Any] {
                    if let imgUrl = imageDict["front_default"] as? String {
                        self.displayImage(urlString: imgUrl)
                    }
                    
                }
            }
            
        }
        task.resume()
    }
    func displayImage(urlString: String) {
        guard let url = URL(string: urlString)
            else {
                print("invalid image  URl")
                return
        }
        let imageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("Error \(err.localizedDescription)")
                return
            }
            if let imgData = data,
               let img = UIImage(data: imgData) {
                DispatchQueue.main.async {
                    self.pokemonImageView.image = img
                }
   
            }
        }
        imageTask.resume()
    }
}





