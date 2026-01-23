import XCTest
@testable import zad1

final class zad1Tests2: XCTestCase {
    
    var vc: ViewController!
    var label: UILabel!

    override func setUpWithError() throws {
        vc = ViewController()
        vc.loadViewIfNeeded()

        label = UILabel()
        vc.label_result = label
    }

    override func tearDownWithError() throws {
        vc = nil
        label = nil
    }

    func testAdditionWithSmallNumbers() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_eq(self)
        XCTAssertEqual(vc.label_result.text, "5.0")
        XCTAssertEqual(vc.label_result.text?.count, 3)
    }
    
    func testAdditionWithBiggerNumbers() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button1(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button0(self)
        vc.button_eq(self)
        XCTAssertEqual(vc.label_result.text, "51.0")
        XCTAssertTrue(vc.label_result.text!.contains("51"))
    }

    func testAdditionWithDecimalNumbers() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 6.28, accuracy: 0.001)
            XCTAssertTrue(result > 6.0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testSubtracting() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_subtract(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, -1.28, accuracy: 0.001)
            XCTAssertLessThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testAddingNegativeNumber() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button_subtract(self)
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, -1.28, accuracy: 0.001)
            XCTAssertLessThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testMultiplying() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_multiply(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 9.45, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testMultiplyingTwoNegativeNumbers() throws {
        vc.label_result.text = ""
        vc.button_subtract(self)
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_multiply(self)
        vc.label_result.text = ""
        vc.button_subtract(self)
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 9.45, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testMultiplyingWithNegativeNumber() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_multiply(self)
        vc.label_result.text = ""
        vc.button_subtract(self)
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, -9.45, accuracy: 0.001)
            XCTAssertLessThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }
    
    func testDivision() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button5(self)
        vc.button_divide(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_dot(self)
        vc.button7(self)
        vc.button8(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 0.661, accuracy: 0.001)
            XCTAssertLessThan(result, 1)
        } else {
            XCTFail("Convertion failed")
        }
    }

    func testModuloOperation() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_mod(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_eq(self)
        if let result = Int(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 2 % 3)
            XCTAssertGreaterThanOrEqual(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }

    func testPowerOperation() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_power(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 8.0, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }

    func testLogOperation() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_dot(self)
        vc.button0(self)
        vc.button_log(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 0.30102999566, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }

    func testDivisionByZeroShowsAlert() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_divide(self)
        vc.label_result.text = ""
        vc.button0(self)
        vc.button_eq(self)
        XCTAssertEqual(vc.label_result.text, "")
        XCTAssertTrue(vc.label_result.text?.isEmpty ?? false)
    }

    func testMultipleAdditions() throws {
        vc.label_result.text = ""
        vc.button1(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_eq(self)
        vc.button_add(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 6.0, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }

    func testMultipleMultiplications() throws {
        vc.label_result.text = ""
        vc.button2(self)
        vc.button_multiply(self)
        vc.label_result.text = ""
        vc.button3(self)
        vc.button_eq(self)
        vc.button_multiply(self)
        vc.label_result.text = ""
        vc.button4(self)
        vc.button_eq(self)
        if let result = Double(vc.label_result.text ?? "") {
            XCTAssertEqual(result, 24.0, accuracy: 0.001)
            XCTAssertGreaterThan(result, 0)
        } else {
            XCTFail("Convertion failed")
        }
    }

}

