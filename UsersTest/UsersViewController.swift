//
//  UsersViewController.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 27.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class UsersViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UILabel!
    private var viewModel: UserListViewModel!
    private let itemIdentifier = "UserViewCell"
    private var array = [UserModel]()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: itemIdentifier, bundle: nil), forCellReuseIdentifier: itemIdentifier)
        viewModel = UserListViewModel()
        bindToViewModel()
    }

    func bindToViewModel() {
        viewModel.users
            .bind(to: tableView.rx.items(cellIdentifier: itemIdentifier)) { _, user, cell in
                let cell = cell as! UserViewCell // swiftlint:disable:this force_cast
                cell.nameView.text = user.fullName
                cell.emailView.text = user.email
                cell.birthView.text = user.formattedBirthday
            }
            .disposed(by: disposeBag)

        let hasItems = viewModel.users.map { !$0.isEmpty }
        hasItems.not().subscribe(tableView.rx.isHidden).disposed(by: disposeBag)
        hasItems.subscribe(placeholderView.rx.isHidden).disposed(by: disposeBag)
    }
}
