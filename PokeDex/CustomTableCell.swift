//
//  CustomTableCell.swift
//  PokeDex
//
//  Created by Cengizhan Kervancı on 13.10.2022.
//

import UIKit

class CustomTableCell: UITableViewCell {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonDetailURL: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
