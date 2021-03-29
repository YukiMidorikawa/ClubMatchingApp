//
//  MatchCell.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/01.
//

import UIKit

class MatchCell: UICollectionViewCell {
    
    // MARK: - Propaties
    
    var viewModel: MatchCellViewModel! {
        didSet {
            userNameLabel.text = viewModel.nameText
            profileImageView.sd_setImage(with: viewModel.profileImageUrl)
//            checkTouch()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.setDimensions(height: 80, width: 80)
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var unreadView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemPink
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()
        
        addSubview(unreadView)
        unreadView.setDimensions(height: 20, width: 20)
        unreadView.layer.cornerRadius = 20 / 2
        unreadView.centerY(inView: profileImageView)
        unreadView.anchor(right: rightAnchor, paddingRight: 0)
//        unreadView.isHidden = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -API
//    func checkTouch() {
//        Service.checkTouch(forMatches: viewModel.uid) { (touch) in
//            self.unreadView.isHidden = touch
//        }
//    }

    
    
}
