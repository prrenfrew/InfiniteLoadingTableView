//
//  PokemonTableViewCell.swift
//  InfiniteLoadingTableView
//
//  Created by MAC on 9/8/20.
//  Copyright © 2020 PaulRenfrew. All rights reserved.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
  
  @IBOutlet weak var pokemonNameLabel: UILabel!
  
  @IBOutlet weak var pokemonImageView: UIImageView!
  
  var needsImage = true

  override func prepareForReuse() {
    super.prepareForReuse()
    self.needsImage = false
    self.pokemonNameLabel.text = ""
    self.pokemonImageView.image = nil
  }
  
  func configure(with pokemon: Pokemon) {
    self.pokemonNameLabel.text = pokemon.name
    if let cachedImage = ImageCache.shared.retrieveImage(with: pokemon.url) {
      self.pokemonImageView.image = cachedImage
    } else {
      URLSession.shared.dataTask(with: pokemon.url) { (data, _, _) in
        guard let data = data else { return }
        guard let pokemonSprite = try? JSONDecoder().decode(PokemonSprite.self, from: data) else { return }
        URLSession.shared.dataTask(with: pokemonSprite.spriteURL) { (data, _, _) in
          guard let data = data else { return }
          guard let pokemonImage = UIImage(data: data) else { return }
          ImageCache.shared.saveImage(with: pokemon.url, image: pokemonImage)
          guard self.needsImage else {
            self.needsImage = true
            return
          }
          DispatchQueue.main.async {
            self.pokemonImageView.image = pokemonImage
          }
        }.resume()
      }.resume()
    }
  }
}
