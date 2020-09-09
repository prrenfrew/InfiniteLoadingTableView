//
//  ViewController.swift
//  InfiniteLoadingTableView
//
//  Created by MAC on 9/8/20.
//  Copyright © 2020 PaulRenfrew. All rights reserved.
//

/*
 DispatchQueues are objects that are a part of Grand Central Dispatch(GCD for short).
 
 GCD is a low-level multithreading C Library.
 
 One of two ways to do multithreading in iOS
 
 2 disptach queues defined for us: Global and Main
 Global - This is where you would do long running tasks, such as network calls
 Main - This is where you do UI updates
 */

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var infiniteTableView: UITableView!
  var pokemon: [Pokemon] = []
  //?limit=60&offset=60.
  let firstPageURLString = "https://pokeapi.co/api/v2/pokemon"
  var pageNumber = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.infiniteTableView.dataSource = self
    self.infiniteTableView.prefetchDataSource = self
    self.infiniteTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
    self.getPokemon()
  }
  
  func getPokemon(with pageNumber: Int = 1) {
    let pokemonPageURLString = self.firstPageURLString + "?limit=20&offset=\(20 * (pageNumber - 1))"
    guard let url = URL(string: pokemonPageURLString) else { return }
    URLSession.shared.dataTask(with: url) { (data, _, _) in
      guard let data = data else { return }
      guard let results = try? JSONDecoder().decode(PokemonResults.self, from: data) else { return }
      self.pokemon.append(contentsOf: results.results)
      DispatchQueue.main.async {
        self.infiniteTableView.reloadData()
      }
    }.resume()
  }
  
  func getNextPage() {
    self.pageNumber += 1
    self.getPokemon(with: self.pageNumber)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.pokemon.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as! PokemonTableViewCell
    cell.configure(with: self.pokemon[indexPath.row])
    return cell
  }
}

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let lastIndexPath = IndexPath(row: self.pokemon.count - 1, section: 0)
    guard indexPaths.contains(lastIndexPath) else { return }
    self.getNextPage()
  }
}
