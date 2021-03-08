//
//  HomeNavigationStackView.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/21.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    // MARK: -Propaties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    let unreadView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemPink
        return view
    }()
    
    // MARK: -Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        settingButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton, UIView(), tinderIcon, UIView(), messageButton].forEach { (view) in
            addArrangedSubview(view)
        }
        
        messageButton.addSubview(unreadView)
        unreadView.setDimensions(height: 10, width: 10)
        unreadView.layer.cornerRadius = 10 / 2
        unreadView.anchor(top: topAnchor, right: rightAnchor, paddingTop: 45, paddingRight: 15)
        
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingButton.addTarget(self, action: #selector(hundleShowSettings), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(hundleShowMessages), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hundleShowSettings() {
        delegate?.showSettings()
    }
    
    @objc func hundleShowMessages() {
        delegate?.showMessages()
    }
    
}
