//
//  GetThemeByIdUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 14/08/2023.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which obtains a``UserTheme`` by Id
///
@dynamicCallable
public class GetThemeByIdUseCase {
    
    @LazyInjected(\.themeRepository) private var themeRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository
    
    public init() {}
    
    public init(themeRepository: ThemeRepository) {
        self.themeRepository = themeRepository
    }
    
    public func dynamicallyCall(withArguments args: [String]) -> AnyPublisher<UserTheme, Error> {
        guard let idTheme = args.first else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return Publishers.CombineLatest(
            themeRepository.findTheme(byIdTheme: idTheme),
            userDataRepository.userData)
        .map { theme, userData in UserTheme(theme: theme, userData: userData) }
        .eraseToAnyPublisher()
    }
}

