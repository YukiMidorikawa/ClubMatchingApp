//
//  MessageCell.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/13.
//

import UIKit

protocol MessageCellDelegate: class {
    func goProfile(_ cell: MessageCell, wantsToOpen user: User)
}

class MessageCell: UICollectionViewCell {
    
    //MARK: - Propaties
    
    weak var delegate: MessageCellDelegate?

    var message: Message? {
        didSet{ configure() }
    }

    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImageView.setDimensions(height: 36, width: 36)
        profileImageView.layer.cornerRadius = 36/2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 21
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,
                                                                 constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        
        configureGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Helpers
    
    //デリゲートで書くしか
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("タップ")
        guard let user = message?.user else { return }
        delegate?.goProfile(self, wantsToOpen: user)
    }
    
    
    // MARK: -Helpers
    
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        bubbleLeftAnchor.isActive = viewModel.leftAncherActive
        bubbleRightAnchor.isActive = viewModel.rightAncherActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    func configureGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.profileImageView.addGestureRecognizer(tap)
    }
}
