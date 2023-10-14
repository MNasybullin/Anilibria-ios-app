//
//  HasCustomView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

/// The HasCustomView protocol defines a customView property for UIViewControllers to be used in exchange of the regular view property.
/// In order for this to work, you have to provide a custom view to your UIViewController at the loadView() method.
public protocol HasCustomView {
    associatedtype CustomView: UIView
}

extension HasCustomView where Self: UIViewController {
    /// The UIViewController's custom view.
    public var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}
