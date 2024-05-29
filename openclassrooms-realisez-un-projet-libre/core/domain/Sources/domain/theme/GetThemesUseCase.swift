//
//  GetThemesUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which obtains an exhaustive Array of ``UserTheme``
///
@dynamicCallable
public class GetThemesUseCase {
    
    @LazyInjected(\.themeRepository) private var themeRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(themeRepository: ThemeRepository) {
        self.themeRepository = themeRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserTheme], Error> {
        Publishers.Zip(
            themeRepository.findMainThemes(),
            userDataRepository.userData)
            .map { themes, userData in
                themes.filter({ theme in
                    theme.themes != nil &&
                    theme.language.prefix(2) == Locale.current.identifier.prefix(2)
                })
                .reduce(into: [Theme]()) { result, mainTheme in
                    var final = mainTheme
                    
                    final.authors = nil
                    final.books = nil
                    final.urls = nil
                    
                    if final.themes != nil {
                        var m = final
                        m.themes = [Theme]()
                        let theme = final.themes!.reduce(into: m) { r, theme in
                            if theme.nbQuotes != 0 {
                                var subTheme = theme
                                subTheme.authors = nil
                                subTheme.books = nil
                                subTheme.urls = nil
                                r.themes?.append(subTheme)
                            }
                        }
                        final = theme
                    }
                    
                    result.append(final)
                }.map { theme in UserTheme(theme: theme, userData: userData) }
            }
            .eraseToAnyPublisher()
    }
}
