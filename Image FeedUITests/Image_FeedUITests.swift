//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Evgenia Kucherenko on 12.08.2024.
//

import XCTest
@testable import Image_Feed

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    

    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
               
        app.launch() // запускаем приложение перед каждым тесто
    }

    func testAuth() throws {
           // тестируем сценарий авторизации
       }
       
    func testFeed() throws {
           // тестируем сценарий ленты
    }
       
    func testProfile() throws {
           // тестируем сценарий профиля
    }
}
