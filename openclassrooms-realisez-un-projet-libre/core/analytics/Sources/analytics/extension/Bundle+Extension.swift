//
//  Bundle+Extension.swift
//  analytics
//
//
//  Created by Damien Gironnet on 24/07/2023.
//

import Foundation

class AnalyticsBundleFinder {}

///
/// Extension of Bundle for Analytics package
///
extension Foundation.Bundle {
    
    static var analytics: Bundle = {
        /* The name of your local package, prepended by "LocalPackages_" */
        let bundleName = "analytics_analytics"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: AnalyticsBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: AnalyticsBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
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
