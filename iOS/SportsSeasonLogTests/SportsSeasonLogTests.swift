import XCTest
@testable import SportsSeasonLog

@MainActor
final class SportsSeasonLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Game(opponent: "Test", score: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Game(opponent: "First", score: ""))
        store.add(Game(opponent: "Second", score: ""))
        XCTAssertEqual(store.items.first?.opponent, "Second")
    }

    func testDeleteItem() {
        let item = Game(opponent: "ToDelete", score: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Game(opponent: "A", score: ""))
        store.add(Game(opponent: "B", score: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Game(opponent: "Item \(i)", score: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Game(opponent: "One", score: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Game(opponent: "Item \(i)", score: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Game(opponent: "Original", score: "")
        store.add(item)
        item.opponent = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.opponent, "Updated")
    }
}
