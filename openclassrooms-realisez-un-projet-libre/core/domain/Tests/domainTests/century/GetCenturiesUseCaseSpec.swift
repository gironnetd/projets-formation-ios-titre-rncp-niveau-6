//
//  GetCenturiesUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import remote
import Factory
import model

@testable import domain

class GetCenturiesUseCaseSpec: QuickSpec {
    
    override func spec() {
        var centuryRepository: CenturyRepository!
        var useCase: GetCenturiesUseCase!

        describe("Get Centuries") {
            context("Succeeded") {
                it("Centuries is Returned") {
                    centuryRepository = TestCenturyRepository(centuries: [
                        Century(idCentury: DataFactory.randomString(), century: "XX"),
                        Century(idCentury: DataFactory.randomString(), century: "-I")
                    ])
                    
                    DataModule.centuryRepository.register { centuryRepository }
                    
                    useCase = GetCenturiesUseCase()
    
                    let centuries = useCase()
                
                    await expect { try centuries.waitingCompletion().first }.to( equal((centuryRepository as? TestCenturyRepository)?.centuries))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    centuryRepository = TestCenturyRepository()
                    
                    DataModule.centuryRepository.register { centuryRepository }
                    
                    useCase = GetCenturiesUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
