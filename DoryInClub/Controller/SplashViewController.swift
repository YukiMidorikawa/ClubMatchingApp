//
//  SplashViewController.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/01.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let controller = HomeViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        
    }
    
    
    func configureUI() {
        configureGradientLayer()
    }
    



}
