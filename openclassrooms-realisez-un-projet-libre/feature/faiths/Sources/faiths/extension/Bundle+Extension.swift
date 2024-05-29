//
//  Bundle+Extension.swift
//  faiths
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation

class FaithsBundleFinder {}

///
/// Extension of Bundle for Faiths package
///
public extension Foundation.Bundle {
    
    static var faiths: Bundle = {
        /* The name of your local package, prepended by "LocalPackages_" */
        let bundleName = "faiths_faiths"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: FaithsBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: FaithsBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
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
