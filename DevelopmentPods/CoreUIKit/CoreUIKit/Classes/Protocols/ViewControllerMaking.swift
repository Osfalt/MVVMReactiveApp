//
//  ViewControllerMaking.swift
//  CoreUIKit
//
//  Created by Dre on 22.01.2020.
//

import UIKit

// MARK: - Protocol
public protocol ViewControllerMaking: AnyObject {

    associatedtype SomeViewController: UIViewController

    static var identifier: String { get }

    static func make() -> SomeViewController

}

// MARK: - Default Implementation
extension ViewControllerMaking where Self: UIViewController {

    public static var identifier: String {
        return String(describing: self)
    }

    public static func make() -> SomeViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: Self.identifier) as? SomeViewController else {
            preconditionFailure("There is no \(Self.identifier) in Main storyboard")
        }
        return vc
    }

}
