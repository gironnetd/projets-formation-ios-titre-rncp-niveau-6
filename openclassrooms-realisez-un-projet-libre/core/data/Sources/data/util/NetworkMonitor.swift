//
//  NetworkMonitor.swift
//  data
//
//  Created by Damien Gironnet on 06/11/2023.
//

import Foundation
import Combine

public protocol NetworkMonitor {
    var isOnline: CurrentValueSubject<Bool, Never> { get }
}
