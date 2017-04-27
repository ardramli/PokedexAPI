//
//  PokedexViewController.swift
//  APiPokedex
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
    @IBOutlet weak var pokedexTableView: UITableView! {
        didSet {
            pokedexTableView.delegate = self
            pokedexTableView.dataSource = self
        }
    }
    
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         1. Send API request to get data
            1.1 get URL
            1.2 you need url section
            1.3 create a URLSossion
            1.4 Start the task
         
         2. Display data
        */
        
        let urlString = "http://pokeapi.co/api/v2/pokemon/?limit=100"
        guard let url = URL(string: urlString)
            else {return}
        
        //if using urlrequest
        //let request = URLRequest(url:url)
        
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
        //let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictData = jsonData as? [String : Any] {
//                    print (dictData)
                    self.populatePokemon(dictData)
                }
            }catch {
                print ("Error when converting to JSON")
            }
    }
        //start the task
        task.resume()
        
    }
    
    func populatePokemon(_ dict : [String : Any]){
        if let list = dict["results"] as? [[String : String]] {
//            print(list[0])
            for info in list {
                let newPokemon = Pokemon(dict: info)
                pokemons.append(newPokemon)
            }
        }
        DispatchQueue.main.async {
            self.pokedexTableView.reloadData()
        }
    }


}


extension PokedexViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell")
            else {return UITableViewCell()}
        
        cell.textLabel?.text = pokemons[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.selectedPokemon = pokemons[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
