//
//  SymbolsViewController.swift
//  Le Baluchon
//
//  Created by damien on 28/06/2022.
//

import UIKit

//
// MARK: - Symbols ViewController
//
class SymbolsViewController: UITableViewController {
    
    private var symbols: [String] = []
    
    weak var rootViewController: ExchangeViewController?
    public var addCurrency: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SymbolTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SymbolTableViewCell")
        tableView.separatorStyle = .none
        ExchangeService.shared.retrieveData(
            from: ExchangeRequest(endPoint: .symbols), callBack: { symbols, error in
                if let error = error,let title = error.rawValue.title, let message = error.rawValue.message {
                    self.presentAlertViewController(title: title, message: message)
                    return
                }
                
                if let symbols = symbols {
                    self.symbols = symbols.map { (key, value) in key + " \(value)" }
                    self.symbols.sort(by: <)
                    self.tableView.reloadData()
                }
            })
    }
    
    func presentAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil )
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.symbols.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SymbolTableViewCell", for: indexPath) as! SymbolTableViewCell
        cell.symbol.text = self.symbols[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = String(self.symbols[indexPath.row].split(separator: " ")[0])
        
        if addCurrency {
            rootViewController?.symbolsCurrenciesForBaseCurrency.append(symbol)
            rootViewController?.retrieveRates()
        } else {
            rootViewController?.baseCurrency = symbol
        }
        dismiss(animated: true, completion: nil)
    }
    
    //setting header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 50))
        headerView.backgroundColor = .systemOrange
        let title = UILabel(frame: CGRect(x:10, y:10, width: tableView.frame.size.width, height: 50))
        title.text = "Choose your Currency :"
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 21)
        headerView.addSubview(title)
        
        title.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
