//
//  PokemonDetailVC.swift
//  pokedexApp
//
//  Created by Jakub Slawecki on 16.01.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel! //done
    @IBOutlet weak var mainImg: UIImageView! // done
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel! // done
    @IBOutlet weak var heightLbl: UILabel! // done
    @IBOutlet weak var pokedexLbl: UILabel! // done
    @IBOutlet weak var weightLbl: UILabel! // done
    @IBOutlet weak var attackLbl: UILabel! //done
    @IBOutlet weak var currentEvoImg: UIImageView! //done
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        
        let nextGenImg = UIImage(named: "\(pokemon.nextGenPokedexId)")
        nextEvoImg.image = nextGenImg
        
        
        // Whatever I write here, will only be called after the network call is complete! ->
        pokemon.downloadPokemonDetail {
            print("is it working!? ")
            self.upadteUI()
        }
        
    }
    
    
    
    func upadteUI() {
        
        attackLbl.text = pokemon.attack
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        defenceLbl.text = pokemon.defence
        pokedexLbl.text = "\(pokemon.pokedexId)"
        typeLbl.text = pokemon.type
        evoLbl.text = "Next evolution: \(pokemon.nextEvolutionTxt.capitalized)"
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
