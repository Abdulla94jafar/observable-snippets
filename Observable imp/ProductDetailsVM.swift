//
//  ProductDetailsVM.swift
//  Logistic App
//
//  Created by Abdulla Jafar on 7/13/20.
//  Copyright © 2020 ABD. All rights reserved.
//

import Foundation



class ProductDetailsVM : ViewModel {


    // MARK: - VIEW PROPERTIES
    var indicatorState = Observable<IndicatorState>(.finished)
    var alertState  = Observable<AlertState>(.successWith(message: ""))
    var imageUrl    = Observable<String>(".........")
    var name        = Observable<String>(".........")
    var price       = Observable<String>(".........")
    var details     = Observable<String>(".........")
    var count       = Observable<String>("1")

    
    
    // MARK: - MODEL
    var company : Company! {
        didSet {
            updateForModelChange()
        }
    }
    var index : Int = 0
    
    let repo = Repository()
    
    init() { }
    
    // MARK: - MODEL UPDATE
    internal func updateForModelChange() {
        let product = company.products[index]
        self.price.value = Formatter.getAmount(product.price as Double, product.currency)
        
        self.name.value = company.products[index].name
        if company.products[index].itemDescription != "" {
            self.details.value = company.products[index].itemDescription
        }
        self.count.value = "\(company.products[index].count)"
        if let fileName = company.products[index].imageFileName {
            self.imageUrl.value = .imageBaseUrl + "/" + fileName
        }
    }

    public func increaseProductCount (_ value : Int) {
        company.products[index].count = value
        company.products[index].increaseCount()
    }
        
    public func decreaseProductCount (_ value : Int) {
        company.products[index].count = value
        company.products[index].decreaseCount()
    }

    public func addToCart (_ value : Int) {
        HapticFeedback.sucess()
        company.products[index].count = value
        company.products[index].added = !company.products[0].added
        repo.save(company: company, withProductAtIndex: index)
        
    }
    
    
}


fileprivate extension String {
    static let buttonAddTitle = NSLocalizedString("add_to_cart_title", comment: "")
    static let buttonRemoveTitle = NSLocalizedString("remove_from_cart_title", comment: "")
    
}
