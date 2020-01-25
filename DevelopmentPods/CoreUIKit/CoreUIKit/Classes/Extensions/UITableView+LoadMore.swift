//
//  UITableView+LoadMore.swift
//  CoreUIKit
//
//  Created by Dre on 25.01.2020.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UITableView {

    public var isShowLoadMoreFooter: BindingTarget<Bool> {
        return makeBindingTarget { tableView, isLoadingMore in
            tableView.tableFooterView = isLoadingMore ? LoadMoreView() : UIView()
        }
    }

}
