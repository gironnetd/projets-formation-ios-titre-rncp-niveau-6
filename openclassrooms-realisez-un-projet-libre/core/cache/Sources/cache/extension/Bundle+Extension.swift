//
//  Bundle+Extension.swift
//  cache
//
//  Created by Damien Gironnet on 11/03/2023.
//

import Foundation

class CacheBundleFinder {}

///
/// Extension of Bundle for Cache package
///
extension Foundation.Bundle {
    
    static var cache: Bundle = {
        /* The name of your local package, prepended by "LocalPackages_" */
        let bundleName = "cache_cache"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CacheBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CacheBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
        ] + Bundle.allBundles.map { $0.bundleURL }
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}
