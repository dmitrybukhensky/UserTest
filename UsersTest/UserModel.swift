//
//  UserModel.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 27.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    dynamic var id = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email = ""
    dynamic var birthdate = Date(timeIntervalSince1970: 1)

    override static func primaryKey() -> String? {
        return "id"
    }

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    var formattedBirthday: String {
        return birthdateFormatter.string(from: birthdate)
    }
}

private let birthdateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    return formatter
}()
