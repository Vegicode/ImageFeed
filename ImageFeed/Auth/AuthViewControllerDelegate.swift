//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Mac on 05.09.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
    func showAlert()
}
