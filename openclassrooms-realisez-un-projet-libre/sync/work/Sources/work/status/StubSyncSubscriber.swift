//
//  StubSyncSubscriber.swift
//  work
//
//  Created by Damien Gironnet on 10/11/2023.
//

import Foundation
import common
import os

public class StubSyncSubscriber: SyncSubscriber {
    public func subscribe() async {
        Log.debug("Subscribing to sync")
    }
}
