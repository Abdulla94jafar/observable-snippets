//
//  ViewModelProtocol.swift
//  Logistic App
//
//  Created by Abdulla Jafar on 7/10/20.
//  Copyright © 2020 ABD. All rights reserved.
//

import Foundation
import UIKit


// MARK: - VIEW MODEL DATA STATE


public enum IndicatorState  {
    case loading
    case finished
}

public enum AlertState {
    case failedWith(error : Error)
    case successWith (message : String)
    public func get() -> String{
        switch self {
        case let .successWith(message):
            return message
        case let .failedWith(error):
            return error.localizedDescription
        }
    }
}







// MARK: - VIEW MODEL PROTOCOL
protocol ViewModel : AnyObject {
    
    var indicatorState : Observable<IndicatorState> { get set }
    
    var alertState : Observable<AlertState> { get set }
    
    func updateForModelChange ()
    
}


// MARK: - VIEW MODEL PROTOCOL BIND METHODS
extension ViewModel {
        
    func bind <Observer : AnyObject ,ValueType> (
        _ observer : Observer,
        initialValue : Bool = true,
        from sourceKeyPath: KeyPath<Self, Observable<ValueType>> ,
        to toKeyPath : ReferenceWritableKeyPath<Observer,ValueType>
    ) {
        var observableOptions : [ObservableOptions] = [.new]
        if initialValue { observableOptions = [.initial,.new] }
        self[keyPath : sourceKeyPath].addObserver(observer, removeIfExists: true, options: observableOptions) { [weak observer] (value, options) in
            observer?[keyPath : toKeyPath] = value
        }
    }


    
    func bindCollection <Observer : AnyObject ,ValueType> (
        _ observer : Observer,
        from sourceKeyPath: KeyPath<Self, Observable<ValueType>>
    ) {
        self[keyPath : sourceKeyPath].addObserver(observer, removeIfExists: true, options: [.new,.initial]) { [weak observer] (value, options) in
            if let table = observer as? UITableView {
                table.reloadData()
            } else if let collection = observer as? UICollectionView {
                collection.reloadData()
            }
        }
    }


    func bind <Observer : AnyObject,ValueType> (
        _ observer : Observer,
        _ sourceKeyPath: KeyPath<Self, Observable<ValueType>>,
        completion : @escaping (ValueType)-> ()
    ) {
        self[keyPath : sourceKeyPath].addObserver(observer, removeIfExists: true, options: [.initial,.new]) {(value , options) in
            completion(value)
        }
    }
}
