//
//  SettingsViewController.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/25.
//

import UIKit
import JGProgressHUD

private let reuseIdentifier = "SettingCell"

protocol SettingsControllerDelegate: class{
    func settingsController(_ controller: SettingsViewController, wantsToUpdate user: User)
    func settingsControllerWantsToLogout(_ controller: SettingsViewController)
}

class SettingsViewController: UITableViewController, AlertDisplayable, SettingsFooterDelegate {
    
    // MARK: -Propaties
    
    private var user: User
    
    private lazy var headerView = SettingsHeader(user: user)
    private let footrView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var delegate: SettingsControllerDelegate?
    
    // MARK: -Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: -Actions
    
    @objc func hundleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func hundleDone() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)
        
        Service.saveUserData(user: user) { (error) in
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
        
    }
    
    // MARK: -API
    
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving image"
        hud.show(in: view)
        
        Service.uploadImage(image: image) { (imageUrl) in
            self.user.imageURLs.append(imageUrl)
            hud.dismiss()
        }
    }
    
    
    
    // MARK: -Helpers
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hundleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hundleDone))
        
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        tableView.tableFooterView = footrView
        footrView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footrView.delegate = self
    }
    
    func handleLogout() {
//        delegate?.settingsControllerWantsToLogout(self)
        showAlertLogout { [self] (_) in
            delegate?.settingsControllerWantsToLogout(self)
        }
    }
}

// MARK: -UITableViewDataSource

extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        
        guard let section = SettingsSections(rawValue: indexPath.section) else { return cell }
        let viewModel = SettingsViewModel(user: user, sections: section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
}

// MARK: -UITableViewDelegate

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
        return section.discription
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else { return 0 }
        return section == .ageRange ? 96 : 44
    }

}

// MARK: -SettingHeaderDelegate

extension SettingsViewController: SettingHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSlect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: -UIImagePickerControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: -SettingsCellDelegate


extension SettingsViewController: SettingsCellDelegate {
    func settingsCell(_ cell: SettingCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: SettingCell, wantsToUpdateUserWith value: String,
                      for section: SettingsSections) {
        switch section {
        
        case .name:
            user.name = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .gender:
            user.gender = value
        case .bio:
            user.bio = value
        case .club:
            user.club = value
        case .ageRange:
            break
        }
        
        print("ユーザー\(user)")
    }
}

//extension SettingsViewController: SettingsFooterDelegate {
//    func handleLogout() {
//        delegate?.settingsControllerWantsToLogout(self)
//    }
//}
