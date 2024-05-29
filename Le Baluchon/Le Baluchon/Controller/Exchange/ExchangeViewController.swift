//
//  ExchangeViewController.swift
//  Le Baluchon
//
//  Created by damien on 27/06/2022.
//

import UIKit

//
// MARK: - Exchange ViewController
//
class ExchangeViewController: UIViewController {


    @IBOutlet private weak var addCurrency: UIButton!
    @IBOutlet private weak var currencyTableView: UITableView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var fromAmount: UITextField! {
        didSet {
            fromAmount.text = "1"
            fromAmount.addDoneCancelToolbar(onDone: (target: self, action: #selector(retrieveRates)))
        }
    }
    
    public var baseCurrency: String = Constants.DEFAULT_BASE_CURRENCY {
        willSet {
            baseCurrencyButton.setTitle(newValue, for: .normal)
            
            guard let cachedRates = UserDefaults.standard.dictionary(forKey: Constants.RATES),
                  let symbolsCurrencies = cachedRates[newValue]
                else {
                symbolsCurrenciesForBaseCurrency = [Constants.DEFAULT_SYMBOL_CURRENCY]
                retrieveRates()
                return
            }
            
            guard let symbols = symbolsCurrencies as? [String: Double] else {
                symbolsCurrenciesForBaseCurrency = [Constants.DEFAULT_SYMBOL_CURRENCY]
                retrieveRates()
                return
            }
            
            symbolsCurrenciesForBaseCurrency = symbols.map { key, value in key }
            retrieveRates()
        }
    }
    
    private var symbolCurrency: String = Constants.DEFAULT_SYMBOL_CURRENCY {
        willSet {
            symbolCurrencyButton.setTitle(newValue, for: .normal)
        }
    }
    
    public var currenciesForBaseCurrency: [String: Double] = [:]
    
    public lazy var symbolsCurrenciesForBaseCurrency: [String] = {
        guard let cachedRates = UserDefaults.standard.dictionary(forKey: Constants.RATES),
              let symbolsCurrencies = cachedRates[baseCurrency]
            else {
            return [symbolCurrency]
        }
        
        guard let symbols = symbolsCurrencies as? [String: Double] else {
            return [symbolCurrency]
        }
        return symbols.map { key, value in key }
    }()
    
    private lazy var baseCurrencyButton: UIButton = {
        let base = UIButton(type: .custom)
        base.setTitle(baseCurrency, for: .normal)
        base.setTitleColor(.black, for: .normal)
        base.backgroundColor = .none
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        base.addTarget(self, action: #selector(presentSymbolsViewController(_:)), for: .touchUpInside)
        return base
    }()
    
    private lazy var keyboardButton: UIButton = {
        let base = UIButton(type: .custom)
        base.addTarget(self, action: #selector(openKeyboard(_:)), for: .touchUpInside)
        base.setImage(UIImage(named: "keyboard"), for: .normal)
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        return base
    }()
    
    private lazy var symbolCurrencyButton: UIButton = {
        let base = UIButton(type: .custom)
        base.setTitle(symbolCurrency, for: .normal)
        base.setTitleColor(.black, for: .normal)
        base.backgroundColor = .none
        base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        base.translatesAutoresizingMaskIntoConstraints = false
        
        return base
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromAmount.leftViewMode = .always
        fromAmount.leftView = baseCurrencyButton
        
        fromAmount.rightViewMode = .always
        fromAmount.rightView = keyboardButton
        
        fromAmount.layer.cornerRadius = 4.0
        fromAmount.layer.borderWidth = 1
        fromAmount.layer.borderColor = UIColor.orange.cgColor
        
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.separatorStyle = .none
        
        retrieveRates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Exchange Rates"
    }
    
    @objc private func openKeyboard(_ sender: AnyObject) {
        fromAmount.becomeFirstResponder()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromAmount.resignFirstResponder()
    }
    
    @IBAction func addCurrency(_ sender: Any) {
        presentSymbolsViewController(nil)
    }
    
    @IBAction func convert(_ sender: Any) {
        retrieveRates()
    }

    @objc func retrieveRates() {
        fromAmount.resignFirstResponder()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        ExchangeService.shared.retrieveData(
            from: ExchangeRequest(endPoint: .latest, baseCurrency: baseCurrencyButton.title(for: .normal), symbolCurrencies: symbolsCurrenciesForBaseCurrency), callBack: { [self] rates, error in
                
                if let error = error,let title = error.rawValue.title, let message = error.rawValue.message {
                    presentAlertViewController(title: title, message: message)
                    activityIndicator.stopAnimating()
                    return
                }
            
            if let rates = rates {
                currenciesForBaseCurrency = rates as! [String: Double]
                symbolsCurrenciesForBaseCurrency = rates.map { key, value in key }
                currencyTableView.reloadData()
                activityIndicator.stopAnimating()
            }
        })
    }
    
    @objc private func presentSymbolsViewController(_ sender: AnyObject?) {
        let symbolsViewController = SymbolsViewController()
        symbolsViewController.rootViewController = self
        if sender == nil {
            symbolsViewController.addCurrency = true
        }
        present(symbolsViewController, animated: true, completion: nil)
    }
    
    @objc private func presentCurrenciesViewController(_ sender: AnyObject) {
        let symbolsViewController = SymbolsViewController()
        symbolsViewController.rootViewController = self
        symbolsViewController.addCurrency = true
        present(symbolsViewController, animated: true, completion: nil)
    }
    
    func presentAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil )
    }
}

extension ExchangeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        symbolsCurrenciesForBaseCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        
        cell.baseCurrency = symbolsCurrenciesForBaseCurrency[indexPath.row]
        cell.commonInit()
        
        let baseCurrencyButton: UIButton = {
            let base = UIButton(type: .custom)
            base.setTitle(cell.baseCurrency, for: .normal)
            base.setTitleColor(.black, for: .normal)
            base.backgroundColor = .none
            base.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            
            base.translatesAutoresizingMaskIntoConstraints = false
            return base
        }()
        
        cell.textField.leftView = baseCurrencyButton
        
        if let currency = currenciesForBaseCurrency[cell.baseCurrency] {
            let conversion = ((Double(fromAmount.text!)!) * (currency))
            
            let formatter: NumberFormatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            if let result = formatter.string(from: conversion as NSNumber) {
                cell.textField.text = "\(result)"
            }
        }
        
        return cell
    }
}

extension ExchangeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension ExchangeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          fromAmount.resignFirstResponder()
          return true
       }
}
