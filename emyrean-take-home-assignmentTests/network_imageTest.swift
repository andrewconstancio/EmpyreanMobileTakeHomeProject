//
//  network_image_test.swift
//  emyrean-take-home-assignment
//
//  Created by Andrew Constancio on 6/2/25.
//

import XCTest
import UIKit
@testable import emyrean_take_home_assignment

// MARK: - NetworkImage Tests
class NetworkImageTests: XCTestCase {
    var sut: NetworkImage!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = NetworkImage(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.studResponseData = nil
        MockURLProtocol.error = nil
    }
    
    func testClient_WhenGivenSuccess_ReturnImage() {
        // Arrange
        let testImage = UIImage(systemName: "person.fill")!
        let testImageData = testImage.pngData()

        MockURLProtocol.studResponseData = testImageData

        let expectation = self.expectation(description: "Image download should succeed")

        var returnedImage: UIImage?

        // Act
        sut.downloadImage(from: "https://test.com/image.png") { image in
           returnedImage = image
           expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 5)

        XCTAssertNotNil(returnedImage)
    }
    
    func testClient_WhenGivenError_ReturnsNilImage() {
        // Arrange
        let expectedError = NSError(domain: "Error", code: 1234, userInfo: nil)
        MockURLProtocol.error = expectedError

        let expectation = self.expectation(description: "Image should be nil")

        var returnedImage: UIImage?

        // Act
        sut.downloadImage(from: "https://test.com/image.png") { image in
            returnedImage = image
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(returnedImage, "Expected nil")
    }
}

