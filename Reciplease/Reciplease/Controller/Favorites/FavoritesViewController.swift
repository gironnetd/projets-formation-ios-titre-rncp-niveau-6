//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by damien on 29/07/2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    public var recipes: [Recipe] = []
    @IBOutlet weak var tableView: UITableView!
    private let segueIdentifier: String = "RecipeDetailSegue"
    
    @IBOutlet weak var informationMessage: UILabel!
    
    private lazy var favoriteService = FavoriteService(
        managedObjectContext: CoreDataStack.shared.managedObjectContext,
        coreDataStack: CoreDataStack.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 22)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let recipes = favoriteService.findAll() else {
            self.recipes = []
            informationMessage.isHidden = false
            self.tableView.reloadData()
            return
        }
        
        if !recipes.isEmpty {
            self.recipes = recipes
            informationMessage.isHidden = true
        } else {
            self.recipes = []
            informationMessage.isHidden = false
        }
        
        self.tableView.reloadData()
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

extension FavoritesViewController: UITableViewDelegate {}

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: segueIdentifier, sender: cell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
