//
//  MessageHelper.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 28.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import Foundation
import UIKit

final class MessageHelper {

    class func showMessage(context: UIViewController, message: String) {
        let alert = UIAlertController(title: "UsersTest", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        context.present(alert, animated: true, completion: nil)
    }
}
