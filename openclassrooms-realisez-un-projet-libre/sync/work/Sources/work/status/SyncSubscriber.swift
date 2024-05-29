//
//  SyncSubscriber.swift
//  work
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation

public protocol SyncSubscriber {
    func subscribe() async
}
