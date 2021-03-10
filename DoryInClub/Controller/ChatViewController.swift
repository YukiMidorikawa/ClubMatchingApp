//
//  ChatViewController.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/03.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class ChatViewController: UICollectionViewController {
    
    // MARK: - Propaties
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false

    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    private var profileButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleProfile), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: -API
    func fetchMessages() {
        showLoader(true)
        Service.fetchMessages(forUser: user) { (messages) in
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                             at: .bottom, animated: true)
        }
    }
    
    // MARK: - Action

    @objc func handleProfile() {
        TransitionProfile(forUser: user)
    }
    
    @objc func hundleDone() {
        self.alert()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        let imageUrl = URL(string: user.imageURLs[0])
        profileButton.sd_setImage(with: imageUrl, for: .normal)
        profileButton.setDimensions(height: 30, width: 30)
        profileButton.layer.cornerRadius = 30 / 2
        
        navigationItem.titleView = profileButton
        navigationController?.navigationBar.tintColor = .systemPink
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()

        let alertButton = UIBarButtonItem(title: "通報", style: .plain,
                                          target: self, action: #selector(hundleDone))
        self.navigationItem.rightBarButtonItem = alertButton
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive

    }
    
    func TransitionProfile(forUser user: User) {
        let controller = ProfileViewController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func alert() {
        let alert: UIAlertController = UIAlertController(title: "問題がありましたか？",
                                                         message: "",
                                                         preferredStyle: .actionSheet)
        let report: UIAlertAction = UIAlertAction(title: "通報",
                                                  style: .default) { (reportAction) in
            //通報
        }
        let release: UIAlertAction = UIAlertAction(title: "マッチを解除",
                                                   style: .default) { (relaeseåcrion) in
            //マッチを解除
            Service.relaseUsers(forCurrentUser: self.user)
            self.navigationController?.popViewController(animated: true)
            
        }
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                  style: .cancel,
                                                  handler: nil)
        
        alert.addAction(report)
        alert.addAction(release)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)

    }


}

extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell

    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatViewController: CustomInputAccessoryViewDelagate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        
        Service.uploadMessage(message, to: user) { (error) in
            if let error = error {
                print("ああああ\(error)")
                return
            }
            
            inputView.clearMessageText()
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    func goProfile(_ cell: MessageCell, wantsToOpen user: User) {
        TransitionProfile(forUser: user)
    }
}

