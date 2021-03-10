//
//  UsersCell.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/02.
//

import UIKit

class UsersCell: UITableViewCell {
    
    // MARK: - Propaties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()
    
    private let unreadView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemPink
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 70, width: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        
        addSubview(unreadView)
        unreadView.setDimensions(height: 20, width: 20)
        unreadView.layer.cornerRadius = 20 / 2
        unreadView.anchor(left: leftAnchor, paddingLeft: 70)
        unreadView.centerY(inView: self)
        unreadView.isHidden = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -API
    func checkRead() {
        guard let user = conversation?.user else { return }
        Service.checkRead(forChatWith: user) { (isRead) in
            self.unreadView.isHidden = isRead
        }
    }
    
    // MARK: - Helper
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = UsersViewModel(conversation: conversation)
        
        usernameLabel.text = conversation.user.name
        messageTextLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        checkRead()
    }

    
    
}
