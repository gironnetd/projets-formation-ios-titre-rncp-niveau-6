//
//  SearchViewController.swift
//  Reciplease
//
//  Created by damien on 19/07/2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var ingredientTextField: UITextField!
    @IBOutlet private weak var ingredientsTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var ingredients: [String] = [] {
        didSet {
            ingredientsTableView.reloadData()
        }
    }
    
    private let segueIdentifier: String = "RecipesSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 22)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.delegate = self
        self.ingredientsTableView.separatorStyle = .none
    }
    
    @IBAction private func addIngredient(_ sender: Any) {
        self.addIngredient()
    }
    
    @IBAction private func clearIngredients(_ sender: Any) {
        self.ingredients.removeAll()
    }
    
    private func addIngredient() {
        if let ingredient = ingredientTextField.text, !ingredient.isEmpty {
            self.ingredients.append(ingredient.capitalized.trimmingCharacters(in: .whitespaces))
            clearIngredientTextField()
        }
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        activityIndicator.startAnimating()
        SearchService.shared.retrieveRecipes(ingredients: ingredients, callBack: { [self] recipes, error in
            if let recipes = recipes {
                activityIndicator.stopAnimating()
                guard !recipes.isEmpty else {
                    presentAlertViewController(title: "No recipes found",
                        message: "Sorry but we couldn't find any recipes matching the ingredients you entered.")
                    return
                }
                performSegue(withIdentifier: segueIdentifier, sender: recipes)
            }
            
            if let error = error {
                activityIndicator.stopAnimating()
                presentAlertViewController(title: error.rawValue.title!, message: error.rawValue.message!)
            }
        })
    }
    
    private func presentAlertViewController(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        clearIngredientTextField()
    }
    
    private func clearIngredientTextField() {
        ingredientTextField.resignFirstResponder()
        ingredientTextField.text = ""
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueIdentifier,
            let destination = segue.destination as? RecipesTableViewController
        {
            if ((sender.self as? [Recipe]) != nil) {
                destination.recipes = sender as! [Recipe]
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.ingredient.text = ingredients[indexPath.row]
        cell.ingredient.accessibilityLabel = cell.ingredient.text
        cell.ingredient.accessibilityHint = cell.ingredient.text
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ingredientTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        return true
    }
}
