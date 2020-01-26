//
//  CGSize+Comparable.swift
//  CoreKit
//
//  Created by Dre on 26.01.2020.
//

import Foundation

extension CGSize: Comparable {

    public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width < rhs.width && lhs.height < rhs.height
    }

}
