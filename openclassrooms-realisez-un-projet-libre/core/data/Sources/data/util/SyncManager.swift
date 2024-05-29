//
//  SyncManager.swift
//  data
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation
import Combine

public protocol SyncManager {
    var isSyncing: CurrentValueSubject<Bool, Never> { get }
    
    func requestSync()

}
