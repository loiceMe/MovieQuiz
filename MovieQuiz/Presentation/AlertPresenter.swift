//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 14.01.2025.
//
import UIKit

class AlertPresenter {
    weak var controller: UIViewController?
    
    func showAlert(alertData: AlertModel) {
        let alert = UIAlertController(title: alertData.title,
                                      message: alertData.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertData.buttonText, style: .default) { _ in
            alertData.completion()
        }
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil)
    }
}
