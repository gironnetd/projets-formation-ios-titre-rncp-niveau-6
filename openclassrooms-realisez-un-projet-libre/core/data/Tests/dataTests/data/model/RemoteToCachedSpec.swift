//
//  RemoteToCachedSpec.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache

class RemoteToCachedSpec: QuickSpec {
    
    override func spec() {
        
        describe("Remote user") {
            context("Mapped as cached") {
                it("Value is equal") {
                    let remoteModel = RemoteUser.testUser()
                    let cached = remoteModel.asCached()
                    
                    expect { cached.id }.to(equal(remoteModel.uid))
                    expect { cached.providerID }.to(equal(remoteModel.providerID))
                    expect { cached.email }.to(equal(remoteModel.email))
                    expect { cached.displayName }.to(equal(remoteModel.displayName))
                    expect { cached.photo }.to(equal(remoteModel.photo))
//                    expect { cached.favourites }.to(equal(remoteModel.favourites?.asCached()))
                }
            }
        }
        
//        describe("Remote favourite") {
//            context("Mapped as cached") {
//                it("Value is equal") {
//                    let remoteModel = RemoteFavourite.testFavourite()
//                    let cached = remoteModel.asCached()
//                    
//                    expect { cached.idDirectory }.to(equal(remoteModel.idDirectory))
//                    expect { cached.idParentDirectory }.to(equal(remoteModel.idParentDirectory))
//                    expect { cached.directoryName }.to(equal(remoteModel.directoryName))
//                    expect { cached.subDirectories.toArray() }.to(equal(remoteModel.subDirectories!.map { $0.asCached() }))
//                    expect { cached.authors }.to(beEmpty())
//                    expect { cached.books}.to(beEmpty())
//                    expect { cached.movements }.to(beEmpty())
//                    expect { cached.themes }.to(beEmpty())
//                    expect { cached.quotes }.to(beEmpty())
//                    expect { cached.pictures }.to(beEmpty())
//                    expect { cached.presentations }.to(beEmpty())
//                    expect { cached.urls }.to(beEmpty())
//                }
//            }
//        }
    }
}
