//
//  LoadMoreView.swift
//  CoreUIKit
//
//  Created by Dre on 18.01.2020.
//

import UIKit

public final class LoadMoreView: UIView {

    // MARK: - Constants
    private enum Constant {
        static let defaultHeight: CGFloat = 44
    }

    // MARK: - Private properties
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        addSubview(activityIndicator)
        setupConstraints()
        sizeToFit()
    }

    // MARK: - Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        sizeToFit()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: bounds.width, height: Constant.defaultHeight)
    }

    // MARK: - Private methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
