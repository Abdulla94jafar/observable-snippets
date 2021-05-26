//
//  ProductDetailsVC.swift
//  Logistic App
//
//  Created by Abdulla Jafar on 7/13/20.
//  Copyright © 2020 ABD. All rights reserved.
//

import UIKit

class ProductDetailsVC: MasterTableVC {
    
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var detailsLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var retailPriceLabel : MainTextField!
    @IBOutlet weak var countTextField : MainTextField!
    @IBOutlet weak var addButton : GradientRoundedButton!
    
    var productsDetailsVM = ProductDetailsVM()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func setupViews() {
        countTextField.keyboardType = .asciiCapableNumberPad
    }
    
    
    override func bindViews() {
        productsDetailsVM.bind(priceLabel, from: \.price, to: \.text!)
        productsDetailsVM.bind(nameLabel, from: \.name, to: \.text!)
        productsDetailsVM.bind(detailsLabel, from: \.details, to: \.text!)
        productsDetailsVM.bind(countTextField, from: \.count, to: \.text!)
        productsDetailsVM.bind(self, \.imageUrl) { [weak self] (value) in
            self?.productImageView.sd_setImage(with: URL(string: value), placeholderImage: UIImage(named: .productPlaceHolder))
        }

    }
    

    // MARK: - ACITONS
    
    @IBAction func increaseCount () {
        HapticFeedback.lightImpact()
        let count = Int(countTextField.text ?? "") ?? 1
        productsDetailsVM.increaseProductCount(count)
    }

    
    @IBAction func decreaseCount  () {
        let count = Int(countTextField.text ?? "") ?? 1
        HapticFeedback.lightImpact()
        productsDetailsVM.decreaseProductCount(count)
    }

    
    @IBAction func addToCart () {
        guard let countText = countTextField.text, !countText.isEmpty else {
            addButton.shakeAnimation()
            return
        }
        view.endEditing(true)
        let count = Int(countText) ?? 1
        productsDetailsVM.addToCart(count)
        self.addButton.isActive = false
        ProgressHUD.showSuccess(withStatus: .productAddedToCart)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self ] in
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
}
fileprivate extension String {
    static let productAddedToCart = NSLocalizedString("product_add_done", comment: "")
}


