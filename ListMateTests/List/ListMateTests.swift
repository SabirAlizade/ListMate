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
    var mockDataManager: MockListDataManager!
    var mockSession: MockProductSession!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "TestRealm"
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        mockDataManager = MockListDataManager()
        mockSession = MockProductSession()
        viewModel = ListViewModel(session: mockSession, manager: mockDataManager)
        mockDelegate = MockListViewModelDelegate()
        viewModel.delegate = mockDelegate
    }

    func testReadDataSuccess() {
        // Given
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        try! realm.write {
            realm.deleteAll()
            realm.add(ListModel(value: ["name": "Test List"]))
        }
        mockDataManager.mockLists = realm.objects(ListModel.self)

        // When
        viewModel.readData()

        // Then
        XCTAssertTrue(mockDelegate.didReloadData)
        XCTAssertEqual(viewModel.lists?.count, 1)
        XCTAssertEqual(viewModel.lists?.first?.name, "Test List")
    }
    
    func testReadDataCallsDelegateReload() {
        // Given
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
        try! realm.write {
            realm.add(ListModel(value: ["name": "Test List"]))
        }
        mockDataManager.mockLists = realm.objects(ListModel.self)

        // When
        viewModel.readData()

        // Then
        XCTAssertTrue(mockDataManager.readDataCalled, "readData was not called on the data manager")
        XCTAssertTrue(mockDelegate.didReloadData, "reloadData was not called on the delegate")
    }

    func testDeleteItemSuccess() {
        // Given
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        try! realm.write {
            realm.deleteAll()
            realm.add(ListModel(value: ["name": "Test List"]))
        }
        mockDataManager.mockLists = realm.objects(ListModel.self)
        viewModel.readData()

        // When
        viewModel.deleteItem(index: 0)

        // Then
        XCTAssertTrue(mockDataManager.deleteDataCalled, "delete was not called on the data manager")
        XCTAssertEqual(viewModel.lists?.count, 0)
    }


    func testUpdateListId() {
        // Given
        let newId = "newListId"

        // When
        viewModel.updateListId(id: newId)

        // Then
        XCTAssertEqual(mockSession.listID, newId)
    }

    func testReadDataErrorHandling() {
        // Given
        mockDataManager.shouldReturnErrorOnRead = true

        // When
        viewModel.readData()

        // Then
        XCTAssertTrue(mockDataManager.readDataCalled, "readData was not called on the data manager")
        XCTAssertFalse(mockDelegate.didReloadData, "reloadData was called on the delegate despite error")
    }

    func testDeleteItemErrorHandling() {
        // Given
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
        try! realm.write {
            realm.add(ListModel(value: ["name": "Test List"]))
        }
        mockDataManager.mockLists = realm.objects(ListModel.self)
        viewModel.readData()
        mockDataManager.shouldReturnErrorOnDelete = true

        // When
        viewModel.deleteItem(index: 0)

        // Then
        XCTAssertTrue(mockDataManager.deleteDataCalled, "delete was not called on the data manager")
        XCTAssertEqual(viewModel.lists?.count, 1, "Item was deleted despite error")
    }
}

class MockListViewModelDelegate: ListViewModelDelegate {
    var didReloadData = false

    func reloadData() {
        didReloadData = true
    }
}
