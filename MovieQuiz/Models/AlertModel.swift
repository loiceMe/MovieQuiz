//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by   Дмитрий Кривенко on 14.01.2025.
//

struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
