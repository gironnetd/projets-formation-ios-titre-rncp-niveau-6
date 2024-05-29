//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by damien on 22/07/2022.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController {

    var recipe: Recipe?
    var ingredients: [Ingredient]?
    
    @IBOutlet weak var ingredientLines: UITableView!
    @IBOutlet weak var recipeDetailheaderView: RecipeDetailHeaderView!
    
    @IBOutlet weak var isFavorites: UIBarButtonItem!
    private let segueIdentifier = "RecipeDirectionSegue"
    
    private lazy var favoriteService = FavoriteService(
        managedObjectContext: CoreDataStack.shared.managedObjectContext,
        coreDataStack: CoreDataStack.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientLines.delegate = self
        ingredientLines.dataSource = self
        ingredients = Array(recipe!.ingredients)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recipe = recipe {
            let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            request.predicate = NSPredicate(format: "label LIKE %@", recipe.label)

            let objects = try? CoreDataStack.shared.managedObjectContext.fetch(request)
            if let result = objects, !result.isEmpty {
                toggleFavoritesBarButtonItem(isFavorites: true)
            } else {
                if tabBarController?.tabBar.selectedItem?.title == "Favorites" {
                    navigationController?.popViewController(animated: true)
                    return
                }
                toggleFavoritesBarButtonItem(isFavorites: false)
            }
        }
        populateHeaderIngredientLines()
    }
    
    private func populateHeaderIngredientLines() {
        if let recipe = recipe {
            recipeDetailheaderView.recipe = recipe
            recipeDetailheaderView.populateHeaderView()
        }
    }
    
    @IBAction func saveOrDeleteToFavorites(_ sender: UIBarButtonItem) {
        if sender.image == UIImage(systemName: "star") {
            if let recipe = recipe {
                favoriteService.save(recipe: recipe)
                toggleFavoritesBarButtonItem(isFavorites: true)
            }
        } else if sender.image == UIImage(systemName: "star.fill") {
            if let recipe = recipe {
                favoriteService.delete(recipe: recipe)
                toggleFavoritesBarButtonItem(isFavorites: false)
            }
        }
    }
    
    private func toggleFavoritesBarButtonItem(isFavorites: Bool) {
        if isFavorites {
            self.isFavorites.image = UIImage(systemName: "star.fill")
            self.isFavorites.tintColor = #colorLiteral(red: 0.008810195141, green: 0.6196215153, blue: 0.4017871618, alpha: 1)
        } else {
            self.isFavorites.image = UIImage(systemName: "star")
            self.isFavorites.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? RecipeDirectionViewController
        {
            destination.recipe = recipe
        }
    }
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ingredients = ingredients {
            return ingredients.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailTableViewCell", for: indexPath) as! RecipeDetailTableViewCell
        
        if let ingredientLine = ingredients?[indexPath.row].text {
            cell.ingredientLine.text = ingredientLine
            cell.ingredientLine.accessibilityHint = cell.ingredientLine.text
            cell.ingredientLine.accessibilityLabel = cell.ingredientLine.text
        }
        return cell
    }
}

extension RecipeDetailViewController: UITableViewDelegate {}
