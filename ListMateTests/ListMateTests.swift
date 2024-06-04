//
//  ListMateTests.swift
//  ListMateTests
//
//  Created by Sabir Alizade on 25.03.24.
//
@testable import ListMate
import XCTest
import RealmSwift


final class ListMateTests: XCTestCase {

    var viewModel: ListViewModel!
       var mockDelegate: MockListViewModelDelegate!
       var mockDataManager: MockDataManager!

       override func setUp() {
           super.setUp()
           mockDataManager = MockDataManager()
           viewModel = ListViewModel(dataManager: mockDataManager)
           mockDelegate = MockListViewModelDelegate()
           viewModel.delegate = mockDelegate
       }

       func testReadDataSuccess() {
           // Given
           mockDataManager.mockLists = [ListModel(value: "Test List")]

           // When
           viewModel.readData()

           // Then
           XCTAssertTrue(mockDelegate.didReloadData)
           XCTAssertEqual(viewModel.lists?.count, 1)
       }
    
    func testReadDataCallsDelegateReload() {
        let mockDataManager = MockDataManager()
        let mockDelegate = MockListViewModelDelegate()
        let viewModel = ListViewModel(dataManager: mockDataManager)
        viewModel.manager = mockDataManager // Assuming you've refactored to inject this dependency
        viewModel.delegate = mockDelegate

        viewModel.readData()

        XCTAssertTrue(mockDataManager.readDataCalled, "readData was not called on the data manager")
        XCTAssertTrue(mockDelegate.didReloadData, "reloadData was not called on the delegate")
    }

}
