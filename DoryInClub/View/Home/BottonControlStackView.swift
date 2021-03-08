//
//  BottonControlStackView.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/22.
//

import UIKit

protocol BottomControlsStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class BottomControlStackView: UIStackView {
    
    // MARK: -Propaties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    // MARK: -Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually

        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)

        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handlelike), for: .touchUpInside)

//        [refreshButton, dislikeButton, superlikeButton, likeButton, boostButton].forEach { (view) in
//            addArrangedSubview(view)
//        }
        [dislikeButton, superlikeButton, likeButton].forEach { (view) in
            addArrangedSubview(view)
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
//        delegate?.handleRefresh()
    }

    @objc func handleDislike() {
//        delegate?.handleDislike()
    }

    @objc func handlelike() {
//        delegate?.handleLike()
    }
    
}
