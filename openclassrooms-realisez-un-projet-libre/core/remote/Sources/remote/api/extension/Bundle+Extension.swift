//
//  Bundle+Extension.swift
//  remote
//
//  Created by damien on 08/12/2022.
//

import Foundation

class RemoteBundleFinder {}

///
/// Extension of Bundle for Remote package
///
extension Foundation.Bundle {
    
    static var remote: Bundle = {
        /* The name of your local package, prepended by "LocalPackages_" */
        let bundleName = "remote_remote"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: RemoteBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: RemoteBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
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
