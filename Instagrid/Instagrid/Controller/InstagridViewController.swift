//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by damien on 27/05/2022.
//

import UIKit

class InstagridViewController: UIViewController {
    
    @IBOutlet private weak var firstArrangement: Arrangement! {
        didSet {
            if firstArrangement.isArrangementSelected {
                currentArrangement = firstArrangement
                switchDisposition(from: nil)
            }
        }
    }
    
    @IBOutlet private weak var secondArrangement: Arrangement! {
        didSet {
            if secondArrangement.isArrangementSelected {
                currentArrangement = secondArrangement
                switchDisposition(from: nil)
            }
        }
    }
    
    @IBOutlet private weak var thirdArrangement: Arrangement! {
        didSet {
            if thirdArrangement.isArrangementSelected {
                currentArrangement = thirdArrangement
                switchDisposition(from: nil)
            }
        }
    }
    
    @IBOutlet private weak var disposition: Disposition! {
        didSet {
            disposition.photos.forEach { photo in photo.instagridViewController = self }
        }
    }
    
    private var currentArrangement: Arrangement? {
        didSet {
            if let previousArrangement = oldValue  {
                previousArrangement.isArrangementSelected = false
                disposition.photos.forEach { photo in photo.photo.image = nil }
                switchDisposition(from: previousArrangement)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGestures()
    }
    
    private func initGestures() {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUpGesture))
        upGesture.direction = .up
        view.addGestureRecognizer(upGesture)
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftGesture))
        leftGesture.direction = .left
        view.addGestureRecognizer(leftGesture)
    }
    
    @objc private func handleUpGesture() {
        guard UIDevice.current.orientation.isPortrait else {
            return
        }
        presentUIActivityViewController()
    }
    
    @objc private func handleLeftGesture() {
        guard UIDevice.current.orientation.isLandscape else {
            return
        }
        presentUIActivityViewController()
    }
    
    private func presentUIActivityViewController() {
        let images = disposition.photos.filter{ photo in photo.photo.image != nil  }.map { photo in photo.photo.image! }
        
        if images.isEmpty {
            return
        }
        
        guard let snapShot = disposition.snapshot() else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [snapShot], applicationActivities: nil)
        activityViewController.modalPresentationStyle = .overFullScreen
        present(activityViewController, animated: true)
        
    }
    
    @IBAction private func selectDispositions(_ sender: Any) {
        if let arrangement = sender as? Arrangement, let currentArrangement = currentArrangement  {
            if arrangement != currentArrangement {
                arrangement.isArrangementSelected = true
                self.currentArrangement = arrangement
            }
        }
    }
    
    private func switchDisposition(from previousArrangement: Arrangement?) {
        
        guard let previousArrangement = previousArrangement  else {
            switch currentArrangement {
            case firstArrangement:
                disposition.fourthPhoto.isHidden = false
                disposition.secondPhoto.isHidden = true
            case secondArrangement:
                disposition.secondPhoto.isHidden = false
                disposition.fourthPhoto.isHidden = true
            case thirdArrangement:
                disposition.secondPhoto.isHidden = false
                disposition.fourthPhoto.isHidden = false
            default:
                break
            }
            return
        }
        
        switch previousArrangement {
        
        case firstArrangement :
            switch currentArrangement {
            case secondArrangement:
                disposition.secondPhoto.isHidden = false
                disposition.fourthPhoto.isHidden = true
            case thirdArrangement:
                disposition.secondPhoto.isHidden = false
            default:
                break
            }
            
        case secondArrangement :
            switch currentArrangement {
            case firstArrangement:
                disposition.fourthPhoto.isHidden = false
                disposition.secondPhoto.isHidden = true
            case thirdArrangement:
                disposition.fourthPhoto.isHidden = false
            default:
                break
            }
            
        case thirdArrangement :
            switch currentArrangement {
            case firstArrangement:
                disposition.secondPhoto.isHidden = true
            case secondArrangement:
                disposition.fourthPhoto.isHidden = true
            default:
                break
            }
        default:
            break
        }
    }
}

