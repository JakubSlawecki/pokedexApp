//
//  Pokemon.swift
//  pokedexApp
//
//  Created by Jakub Slawecki on 09.01.2018.
//  Copyright © 2018 Jakub Slawecki. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!  //done
    private var _pokedexId: Int! // done
    private var _description: String! // no such data in current api
    private var _type: String! // done
    private var _defense: String! //done
    private var _height: String! // done
    private var _weight: String! // done
    private var _attack: String! //done
    private var _nextEvolutionTxt: String! // done
    private var _ability: String!
    private var _pokemonURL: String!
    private var _nextGenPokemonURL: String!
    
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defence: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var ability: String {
        if _ability == nil {
            _ability = ""
        }
        return _ability
    }
    
    
    
    
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var nextGenPokedexId: Int {
        return _pokedexId + 1
    }
    
    
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        self._nextGenPokemonURL = "\(URL_BASE)\(URL_NEXTGENPOKEMON)\(self.pokedexId)/"
    }
    
  
    
    
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
           
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? Int {
                    
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int {
                    
                    self._height = "\(height)"
                }
                
                if let statsAttack = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    
                    if let attack = statsAttack[4]["base_stat"] as? Int {
                        self._attack = "\(attack)"
                    }
                }
                
                if let statsDefense = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    
                    if let defence = statsDefense[3]["base_stat"] as? Int {
                        self._defense = "\(defence)"
                    }
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let abilities = dict["abilities"] as? [Dictionary<String, AnyObject>] , abilities.count > 0 {
                    
                    if let ability = abilities[0]["ability"] as? Dictionary<String, AnyObject> {
                        
                        if let name = ability["name"] as? String {
                            self._ability = name.capitalized
                        }
                        if abilities.count > 1 {
                            for x in 1..<abilities.count {
                                
                                if let ability = abilities[x]["ability"] as? Dictionary<String, AnyObject> {
                                    if let name = ability["name"] as? String {
                                        
                                        self._ability! += ", \(name.capitalized)"
                                    }
                                }
                            }
                        }
                    }
                    print(self._ability)
                    
                } else {
                    self._ability = ""
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    
                    if let type = types[0]["type"] as? Dictionary<String, AnyObject> {
                        
                        if let name = type["name"] as? String {
                            self._type = name.capitalized
                        }
                        if types.count > 1 {
                            for x in 1..<types.count {
                                
                                if let type = types[x]["type"] as? Dictionary<String, AnyObject> {
                                    if let name = type["name"] as? String {
                                        
                                        self._type! += "/\(name.capitalized)"
                                    }
                                }
                            }
                        }
                    }
                    print(self._type)
               
                } else {
                    self._type = ""
                }
            }
            completed()
        }
        
       
        Alamofire.request(_nextGenPokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let chain = dict["chain"] as? Dictionary<String, AnyObject> {
                    
                    if let evolves_to = chain["evolves_to"] as? [Dictionary<String, AnyObject>] {
                        
                        if let species = evolves_to[0]["species"] as? Dictionary<String, AnyObject> {
                            
                            if let name = species["name"] as? String {
                                self._nextEvolutionTxt = name
                                
                            }
                        }
                    }
                }
                print(self._nextEvolutionTxt)
            }
            completed()
        }
    }
}
