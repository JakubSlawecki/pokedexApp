//
//  ViewController.swift
//  pokedexApp
//
//  Created by Jakub Slawecki on 08.01.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit
import AVFoundation // for audio

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon] ()
    var filteredPokemon = [Pokemon] ()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done // on keybord there will be "done" instead of "search" button
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func  initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
  
    // function to parse csv file
    func parsePokemonCSV() { // this is the path to pokemon.csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            // I am using the parsel to pull out the rows
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows { // now we going through each row to get pokeId and the name of the pokemon
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId) // I am creating an object - poke
                pokemon.append(poke)  // and I pass that to array
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
                
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            }
            
            return cell  //taht will go to the PokeCell and ll asign name and thumbImg
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
       
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
       
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
       
        return pokemon.count
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
   
    
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2 // that will set transparency to a button
        
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true) //that will get rid of the keyboard after user will click search btn
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
           
            inSearchMode = false
            collection.reloadData() // if user deleted text from searchBar that ll reloadData to normal version
            view.endEditing(true) // that will get rid of the keyboard after user will delete any text from searchBar
        
        } else {
           
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased() // that will lovercase text that user might type into search bar
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil}) //$0 is just placeholder forEach objectIn Array
            collection.reloadData()                         // that will refresh our list of pokemons with new data
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVS = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVS.pokemon = poke
                }
            }
        }
    }


}




























