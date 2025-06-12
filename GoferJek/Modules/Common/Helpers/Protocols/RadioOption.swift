//
//  RadioOption.swift
//  GoferHandy
//
//  Created by trioangle on 22/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation

protocol RadioItem : Equatable{
    func setSelected(_ selected : Bool)
}
class RadionHandler <Radio : RadioItem>{
    var items : [Radio]
    var selected : Radio?
    private var onSelectAction : ((Radio)->())?
    init(items : [Radio]){
        self.items = items
    }
    func select(_ selected : Radio){
        self.selected = selected
        
        for item in self.items{
            item.setSelected(item == selected)
        }
        self.onSelectAction?(selected)
        
    }
    
    func onSelect(_ action : @escaping (Radio)->()){
        self.onSelectAction = action
    }
}
