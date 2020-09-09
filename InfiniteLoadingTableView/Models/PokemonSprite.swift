//
//  PokemonSprite.swift
//  InfiniteLoadingTableView
//
//  Created by MAC on 9/8/20.
//  Copyright © 2020 PaulRenfrew. All rights reserved.
//

import Foundation

struct PokemonSprite: Decodable {
  let spriteURL: URL
  
  enum CodingKeys: String, CodingKey {
    case sprites
  }
  
  enum SpriteContainerCodingKeys: String, CodingKey {
    case frontImageURL = "front_default"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let spriteContainer = try container.nestedContainer(keyedBy: SpriteContainerCodingKeys.self, forKey: .sprites)
    self.spriteURL = try spriteContainer.decode(URL.self, forKey: .frontImageURL)
  }
}
