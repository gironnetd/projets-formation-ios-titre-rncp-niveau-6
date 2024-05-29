//
//  GetDailyPicturesUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import Combine
import model
import data
import preferences
import Factory
import UIKit
import common

///
/// A use case which obtains an exhaustive Array of ``UserPicture``
///
@dynamicCallable
public class GetForyouPicturesUseCase {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.userDataRepository) private var userDataRepository
    @LazyInjected(\.pictureRepository) private var pictureRepository
    
    public init() {}
    
    public init(pictureRepository: PictureRepository) {
        self.pictureRepository = pictureRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserPicture], Error> {
        Publishers.Zip(
            userDataRepository.userData,
            (olaPreferences.hasDateChanged ?
             pictureRepository.findAllPictures().map {
                 $0.filter({ picture in
                     picture.topics != nil &&
                     picture.topics![0].language.prefix(2) == Locale.current.identifier.prefix(2) })
                 .shuffled().prefix(isTablet ? 6 : 4)
             }.map { Array($0) }.eraseToAnyPublisher() :
                olaPreferences.dailyPictureIds
                .flatMap { ids -> AnyPublisher<[Picture], Error> in
                    ids.publisher.flatMap { self.pictureRepository.findPicture(byIdPicture: $0) }
                        .collect().eraseToAnyPublisher()
                }.eraseToAnyPublisher()
            )
        )
        .map { [self] userData, pictures in
            let dailyPictures = pictures.sorted(by: { ($0.height * 100 / $0.width) > ($1.height * 100 / $1.width) })
            if olaPreferences.hasDateChanged {
                olaPreferences.setDailyPictureIds(ids: dailyPictures.map { $0.idPicture })
            }
                            
            return dailyPictures.map { UserPicture(picture: $0, userData: userData) }
        }
        .eraseToAnyPublisher()
    }
}
