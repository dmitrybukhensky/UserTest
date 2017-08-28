//
//  CreateUserViewController.swift
//  UsersTest
//
//  Created by Dmitry Bukhensky on 27.08.17.
//  Copyright © 2017 DmitryBukhensky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let birthdateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.none
    return dateFormatter
}()

class CreateUserViewController: UIViewController {
    private var viewModel: UserViewModel!
    private let disposeBag = DisposeBag()
    fileprivate var keyboardOffset: CGFloat = 0.0
    @IBOutlet weak var idView: UITextField!
    @IBOutlet weak var firstNameView: UITextField!
    @IBOutlet weak var lastNameView: UITextField!
    @IBOutlet weak var emailView: UITextField!
    @IBOutlet weak var birthView: UITextField!

    private func bindToViewModel() {
        idView.rx.text
            .bind(to: viewModel.id)
            .addDisposableTo(disposeBag)

        firstNameView.rx.text
            .bind(to: viewModel.firstName)
            .addDisposableTo(disposeBag)

        lastNameView.rx.text
            .bind(to: viewModel.lastName)
            .addDisposableTo(disposeBag)

        emailView.rx.text
            .bind(to: viewModel.email)
            .addDisposableTo(disposeBag)

        let birthdatePicker = birthView.inputView as! UIDatePicker // swiftlint:disable:this force_cast
        birthdatePicker.rx.value
            .bind(to: viewModel.birthdate)
            .addDisposableTo(disposeBag)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePicker()
        initKeyboardEvents()

        viewModel = UserViewModel()
        bindToViewModel()
    }

    private func initDatePicker() {
        let birthdatePicker = UIDatePicker()
        birthdatePicker.datePickerMode = .date
        birthView.inputView = birthdatePicker
        birthdatePicker.rx.value
            .map { date in birthdateFormatter.string(from: date) }
            .bind(to: birthView.rx.text)
            .addDisposableTo(disposeBag)
    }

    private func resetFields() {
        idView.text = nil
        firstNameView.text = nil
        lastNameView.text = nil
        emailView.text = nil
    }

    @IBAction func onSaveTap() {
        do {
            try viewModel.save()
            MessageHelper.showMessage(context: self, message: "Данные сохранены")
            resetFields()
            viewModel = UserViewModel()
            bindToViewModel()
        } catch {
            MessageHelper.showMessage(context: self, message: "Ошибка при сохранении данных")
        }
    }
}

// MARK: - Keyboard
extension CreateUserViewController {

    func initKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateUserViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(CreateUserViewController.dismissKeyboard)))
    }

    fileprivate dynamic func dismissKeyboard() {
        view.endEditing(true)
    }

    fileprivate func needOffset() -> Bool {
        return idView.isEditing == false && firstNameView.isEditing == false
    }

    fileprivate dynamic func keyboardWillShow(notification: NSNotification) {
        if needOffset() {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if view.frame.origin.y == 0 {
                    keyboardOffset = keyboardSize.height / 2
                    self.view.frame.origin.y -= keyboardOffset
                }}
        }
    }

    fileprivate dynamic func keyboardWillHide(notification: NSNotification) {
        if needOffset() {
            if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                if view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardOffset
                }
            }
        }
    }

}
