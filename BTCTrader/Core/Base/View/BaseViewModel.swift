//
//  BaseViewModel.swift
//  BTCTrader
//
//  Created by Yahya Can Özdemir on 26.11.2024.
//

protocol BaseViewModel {
    associatedtype EventType
    var eventTrigger: ((_ type: EventType)-> Void)? { get set }
    func start()
}
