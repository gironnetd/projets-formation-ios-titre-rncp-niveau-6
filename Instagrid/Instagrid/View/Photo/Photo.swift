//
//  Photo.swift
//  Instagrid
//
//  Created by damien on 01/06/2022.
//

import UIKit

@IBDesignable class Photo: UIView, UINavigationControllerDelegate {

    @IBOutlet private var contentView: UIButton!
    @IBOutlet private weak var plus: UIImageView!
    @IBOutlet weak var photo: UIImageView!
    
    weak var instagridViewController: InstagridViewController?
    
    private lazy var imagePicker = UIImagePickerController()

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: Photo.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addTarget(self, action: #selector(showImagePicker(_:)), for: .touchUpInside)
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc private func showImagePicker(_ sender: Any) {
        guard let instagridViewController = instagridViewController else {
            return
        }
        instagridViewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension Photo: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
