//
//  RecipesTableViewController.swift
//  Reciplease
//
//  Created by damien on 20/07/2022.
//

import UIKit
import Kingfisher

class RecipesTableViewController: UITableViewController {
    
    public var recipes: [Recipe] = []
    private let segueIdentifier: String = "RecipeDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let recipe = recipes[indexPath.row]
        
        cell.recipe = recipe
        cell.populateTableViewCell()
        cell.recipeImage.kf.setImage(with: URL(string: recipe.imageUrl), completionHandler: { result in
            switch result {
            case .success(let image):
                if let image = image.image.pngData() {
                    self.recipes[indexPath.row].recipeImage = image
                }
            case .failure(let error):
                print(error)
            }
        })
                
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: segueIdentifier, sender: cell)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? RecipeDetailViewController,
            let recipeIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.recipe = recipes[recipeIndex]
        }
    }
}
