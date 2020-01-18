//
//  UITableView+EmptyCells.swift
//  CoreUIKit
//
//  Created by Dre on 18.01.2020.
//

import UIKit

extension UITableView {

    public func hideEmptyCells() {
        tableFooterView = UIView()
    }

}
