//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import UIKit

//
// MARK: - Translation ViewController
//
class TranslationViewController: UIViewController {
    
    @IBOutlet private weak var fromTranslation: UITextView!
    @IBOutlet private weak var toTranslation: UITextView!
    
    @IBOutlet private  weak var languageTranslation: UILabel!
    
    private let defaultLanguageTranslation = "en"
    
    @IBOutlet private weak var autoDetectedLanguage: UILabel!
    @IBOutlet private weak var chooseLanguage: UIStackView!
    private var languages: [String] = []
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseLanguage(sender:))))
        
        if let languageTranslation = userDefaults.string(forKey: Constants.TRANSLATION_LANGUAGE) {
            self.languageTranslation.text = languageTranslation.uppercased()
        } else {
            userDefaults.set(defaultLanguageTranslation, forKey: Constants.TRANSLATION_LANGUAGE)
            self.languageTranslation.text = defaultLanguageTranslation.uppercased()
        }
        
        fromTranslation.layer.cornerRadius = 4.0
        fromTranslation.layer.borderWidth = 1
        fromTranslation.layer.borderColor = UIColor.orange.cgColor
        
        toTranslation.layer.cornerRadius = 4.0
        toTranslation.layer.borderWidth = 1
        toTranslation.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Translation"
    }
    
    @objc private func chooseLanguage(sender: Any?) {
        let alert = UIAlertController(title: "Choose Language", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.translate()
        }))
        
        TranslationService.shared.retrieveLanguages(callBack: { languages, error in
            if let languages = languages {
                self.languages = languages
                self.present(alert,animated: true, completion: nil )
            }
        })
    }
    
    @IBAction private func translate(_ sender: Any) {
        translate()
    }
    
    private func translate() {
        guard !fromTranslation.text.isEmpty else {
            presentAlertViewController(title: "No text to translate", message:
                                        "Sorry, but you have not enter text to translate")
            
            return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        TranslationService.shared.retrieveData(from: fromTranslation.text) { [self] result, error in
            guard error == nil else {
                switch error {
                case .BadRequest :
                    presentAlertViewController(title: "Oops, It's Weird", message:
                                                "You're trying to translate into the same language")
                case .NotFound:
                    presentAlertViewController(title: "Language Not Found", message:
                                                "The text you entered does not match any language")
                default:
                    if let error = error,let title = error.rawValue.title, let message = error.rawValue.message {
                        presentAlertViewController(title: title, message: message)
                        return
                    }
                }
                activityIndicator.stopAnimating()
                return
            }
            
            if let detection = result?.detection {
                autoDetectedLanguage.text = detection.uppercased()
            }
            
            if let translation = result?.translation {
                toTranslation.text = translation
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func presentAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTranslation.resignFirstResponder()
    }
}

extension TranslationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        fromTranslation.text = ""
        toTranslation.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            fromTranslation.resignFirstResponder()
            translate()
            return false
        }
        return true
    }
}

extension TranslationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}

extension TranslationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.languageTranslation.text = languages[row].uppercased()
        userDefaults.set(languages[row].uppercased(), forKey: Constants.TRANSLATION_LANGUAGE)
    }
}
