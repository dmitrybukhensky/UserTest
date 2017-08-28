//
//  UserListViewModel.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 27.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Realm
import RxRealm
import RealmSwift

class UserListViewModel {
    let users: Observable<[UserModel]>

    init() {
        let realm = try! Realm() // swiftlint:disable:this force_try
        let userResults = realm.objects(UserModel.self)
        users = Observable.array(from: userResults)
    }
}
