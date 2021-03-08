//
//  AlertDisplayable.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/23.
//

import UIKit

protocol AlertDisplayable { }

extension AlertDisplayable where Self: UIViewController {
    func showAlertLogout(completion: @escaping(NSObject) -> Void) {
        let alert = UIAlertController(title: "Logout",
                                      message: "Do you really want to log out",
                                      preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout",
                                         style: .default) { (action) in
            completion(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension AlertDisplayable where Self: UIViewController {
    func showAlertReport(completion: @escaping(NSObject) -> Void) {
        let alert: UIAlertController = UIAlertController(title: "問題がありましたか？",
                                                         message: "",
                                                         preferredStyle: .actionSheet)
        let report: UIAlertAction = UIAlertAction(title: "通報",
                                                  style: .default) { (reportAction) in
            //通報
            completion(reportAction)
        }
        let release: UIAlertAction = UIAlertAction(title: "マッチを解除",
                                                   style: .default) { (relaeseåcrion) in
            //マッチを解除
            completion(relaeseåcrion)
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
