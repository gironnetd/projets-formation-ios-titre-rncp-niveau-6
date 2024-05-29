//
//  RecipeDescriptionViewController.swift
//  Reciplease
//
//  Created by damien on 25/07/2022.
//

import UIKit
import WebKit

class RecipeDirectionViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recipe = recipe {
            if !recipe.url.contains("https") {
                recipe.url = recipe.url.replacingOccurrences(of: "http", with: "https")
            }
            
            if let url = URL(string: recipe.url) {
                activityIndicator.startAnimating()
                webView.load(URLRequest(url: url))
            }
        }
    }
}

extension RecipeDirectionViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
