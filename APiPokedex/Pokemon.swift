//
//  Pokemon.swift
//  APiPokedex
//
//  Created by ardMac on 25/04/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

import Foundation

class Pokemon {
    var name : String = ""
    var url : String = ""
    
    init(dict : [String : String]) {
        name = dict["name"] ?? "Default Name"
        url = dict["url"] ?? ""
    }
}
