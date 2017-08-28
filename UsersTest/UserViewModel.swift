//
//  UserViewModel.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 27.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class UserViewModel {
    let id = Variable<String?>(nil)
    let firstName = Variable<String?>(nil)
    let lastName = Variable<String?>(nil)
    let email = Variable<String?>(nil)
    let birthdate = Variable<Date?>(nil)
    let model = UserModel()

    public func save() throws {
        try validate()

        let realm = try! Realm() // swiftlint:disable:this force_try
        model.id = id.value!
        model.firstName = firstName.value!
        model.lastName = lastName.value!
        model.email = email.value!
        model.birthdate = birthdate.value!

        try realm.write {
            realm.add(model)
        }
    }

    private func validate() throws {
        guard let id = id.value, !id.isEmpty else {
            throw UserValidationError.id
        }
        guard let firstName = firstName.value, !firstName.isEmpty else {
            throw UserValidationError.firstName
        }
        guard let lastName = lastName.value, !lastName.isEmpty else {
            throw UserValidationError.lastName
        }
        guard let email = email.value, !email.isEmpty, email.contains("@") else {
            throw UserValidationError.email
        }
        guard birthdate.value != nil else {
            throw UserValidationError.birthdate
        }
    }
}

enum UserValidationError: Error {
    case id
    case firstName
    case lastName
    case email
    case birthdate
}
