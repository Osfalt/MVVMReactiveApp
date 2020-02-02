//
//  Paginator.swift
//  MVVMReactiveApp
//
//  Created by Dre on 02.02.2020.
//  Copyright © 2020 Andrey Sidorovnin. All rights reserved.
//

import Foundation

final class Paginator {

    // MARK: - Private Types
    private enum Constant {
        static let firstPage = 1
        static let defaultPerPage = 30
    }

    // MARK: - Internal Properties
    private(set) var page = Constant.firstPage
    private(set) var perPage: Int
    private(set) var isLastPage = false

    var isFirstPage: Bool {
        return page == Constant.firstPage
    }

    // MARK: - Init
    init(perPage: Int = Constant.defaultPerPage) {
        self.perPage = perPage
    }

    // MARK: - Internal Methods
    func reset() {
        page = Constant.firstPage
        isLastPage = false
    }

    func updatePage(withCurrentItemsCount currentItemsCount: Int,
                    fetchedItemsCount: Int,
                    isFromCache: Bool = false)
    {
        isLastPage = (fetchedItemsCount == 0 && !isFromCache)
                  || (currentItemsCount == 0 && fetchedItemsCount < perPage)

        if fetchedItemsCount > 0 {
            page += 1
        }
    }

}
