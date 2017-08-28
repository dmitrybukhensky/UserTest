//
//  RxNot.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 28.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

extension ObservableType where E == Bool {
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}
