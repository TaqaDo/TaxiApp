//
//  LocationInputCell.swift
//  TaxiApp
//
//  Created by talgar osmonov on 3/4/21.
//

import UIKit
import SnapKit
import MapKit

class LocationInputCell: UITableViewCell {
    
    static let reuseIdentifier = "ReuseLocCell"

    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Beksultan Osmonov"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.text = "Tika Mukambetova"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel, adressLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    //
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    private func configure() {
        backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(labelStack)
    }
    
    private func addConstraints() {
        labelStack.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(40)
        }
    }
    
    func setupData(placeMark: MKPlacemark) {
        titleLabel.text = placeMark.name
        adressLabel.text = placeMark.address
        
    }
}


