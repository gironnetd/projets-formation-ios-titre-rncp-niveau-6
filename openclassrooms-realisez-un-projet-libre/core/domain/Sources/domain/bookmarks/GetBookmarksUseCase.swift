//
//  GetBookmarksUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 19/11/2023.
//

import Foundation
import Combine
import model
import data
import Factory
import common

///
/// A use case which obtains an Array ``UserResource`` by  Id
///
@dynamicCallable
public class GetBookmarksUseCase {
    
    @LazyInjected(\.userDataRepository) private var userDataRepository
    @LazyInjected(\.quoteRepository) private var quoteRepository
    @LazyInjected(\.pictureRepository) private var pictureRepository
    @LazyInjected(\.presentationRepository) private var biographyRepository
    
    public init() {}
    
    public func dynamicallyCall(withArguments args: [[Bookmark]]) -> AnyPublisher<[some UserResource], Error> {
        guard let bookmarks = args.first else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return Publishers.Zip4(
            Publishers.Sequence(sequence: bookmarks.filter { $0.kind == ResourceKind.quote } ).flatMap { bookmark in
                self.quoteRepository.findQuote(byIdQuote: bookmark.idResource)
            }.collect(),
            Publishers.Sequence(sequence: bookmarks.filter { $0.kind == ResourceKind.picture } ).flatMap { bookmark in
                self.pictureRepository.findPicture(byIdPicture: bookmark.idResource)
            }.collect(),
            Publishers.Sequence(sequence: bookmarks.filter { $0.kind == ResourceKind.biography } ).flatMap { bookmark in
                self.biographyRepository.findPresentation(byIdPresentation: bookmark.idResource)
            }.collect(),
            userDataRepository.userData)
        .map { quotes, pictures, presentations, userData in
            let resources: [UserResource] = quotes.map { UserQuote(quote: $0, userData: userData) } +  pictures.map { UserPicture(picture: $0, userData: userData) } + presentations.map { UserBiography(presentation: $0, userData: userData) }
            
            return resources
        }
        .eraseToAnyPublisher()
    }
}
