//
//  MessagesViewController.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/30.
//

import UIKit

private let reuseIdentifier = "Cell"

class MessagesViewController: UITableViewController {
    
    // MARK: - Propaties
    
    private let user: User
    private let headerView = MatchHeader()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    private var isReadList = [Bool]()
    private var isRead = true
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        fetchMatches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
        fetchConversations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchMatches() {
        Service.fetcheMatches { (mathces) in
            self.headerView.matches = mathces
        }
    }
    
    func fetchConversations() {
        showLoader(true)
        print("👀fetchConversations()")
        Service.fetchConversations { (conversations) in
            print("👀conversations.count: \(conversations.count)")
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            //ここでconversationが最後のものだけにフィルタリング？
            //今回の場合だとこれで整合性が取れる
            //この2の部分を普遍的なものにする
            if self.conversations.count == 2 {
                self.fetchIsReadList()
            }
        }
    }
    
    func fetchIsReadList() {
        self.isReadList.removeAll()
        conversationsDictionary.values.forEach({ conversation in
            Service.checkIsRead(forChatWith: conversation.user) { (isRead) in
                guard self.conversationsDictionary.count >= self.isReadList.count else { return }
                print("👀self.conversationsDictionary.count: \(self.conversationsDictionary.count)")
                print("👀self.isReadList.count: \(self.isReadList.count)")
                self.isReadList.append(isRead)
                let isLatestData = self.isReadList.count == self.conversationsDictionary.count
                if isLatestData { self.fetchReadCompletion() }
            }
        })
    }
    
    func fetchReadCompletion() {
        tableView.reloadData()
        showLoader(false)
    }
    
    func updateRead(forUser user: User) {
        Service.updateRead(wantToCheckWith: user)
    }

    // MARK: - Helpers
    
    func configureTableView() {
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()
        
        tableView.register(UsersCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        headerView.delegate = self
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
    }
    
    func configureNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func showChatViewController(forUser user: User) {
        let controller = ChatViewController(user: user)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MessagesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UsersCell
        cell.conversation = conversations[indexPath.row]
        if isReadList.count > indexPath.row {
            cell.isRead = isReadList[indexPath.row]
            print("isReadList = \(self.isReadList)")
            print("呼ばれる順番2、値を渡す＝\(isReadList[indexPath.row])")
            cell.configure()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = UIColor(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        //ここに未読既読の処理
        updateRead(forUser: user)
        showChatViewController(forUser: user)
    }
}

// MARK: - MatchHeaderDelegate

extension MessagesViewController: MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeader, wantsToStartChatWith uid: String) {
        Service.fetchUser(withUid: uid) { (user) in
            print("kokokokok\(user.name)")
            
            self.showChatViewController(forUser: user)
 
            
        }
    }

}

// MARK: - UsersCellDelegate

extension MessagesViewController: UsersCellDelegate {
    func usersCell(_ cell: UsersCell, wantsToCheck user: User) {
        print("===")
    }
}

