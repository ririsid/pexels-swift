import XCTest
@testable import Pexels

final class APIParameterTypesTests: XCTestCase {
    func testAPIParameterable() {
        let rawRepresentableWithString = APIParameterTypes.Orientation.landscape
        let rawRepresentableWithInt = APIParameterTypes.Page(1)

        XCTAssert(rawRepresentableWithString.name == "orientation")
        XCTAssert(rawRepresentableWithString.value == "landscape")
        XCTAssertNotNil(rawRepresentableWithInt)
        XCTAssert(rawRepresentableWithInt!.name == "page")
        XCTAssert(rawRepresentableWithInt!.value == "1")
    }

    func testQuery() {
        let queryNature = APIParameterTypes.Query("nature")

        XCTAssertNotNil(queryNature)
        XCTAssert(queryNature!.name == "query")
        XCTAssert(queryNature!.value == "nature")
    }

    func testQueryWithRawValue() {
        let queryPeople = APIParameterTypes.Query(rawValue: "people")

        XCTAssertNotNil(queryPeople)
        XCTAssert(queryPeople!.name == "query")
        XCTAssert(queryPeople!.value == "people")
    }

    func testQueryWithEmptyValue() {
        let queryWithEmptyValue = APIParameterTypes.Query("")

        XCTAssertNil(queryWithEmptyValue)
    }

    func testOrientation() {
        let orientationLandscape = APIParameterTypes.Orientation.landscape

        XCTAssert(orientationLandscape.name == "orientation")
        XCTAssert(orientationLandscape.value == "landscape")
    }

    func testSize() {
        let sizeLarge = APIParameterTypes.Size.large

        XCTAssert(sizeLarge.name == "size")
        XCTAssert(sizeLarge.value == "large")
    }

    func testColor() {
        let colorRed = APIParameterTypes.Color.red

        XCTAssert(colorRed.name == "color")
        XCTAssert(colorRed.value == "red")
    }

    func testColorWithHexColorCode() {
        let colorHexColorCode_ffffff = APIParameterTypes.Color.hexColorCode("#ffffff")
        let colorHexColorCode_fff = APIParameterTypes.Color.hexColorCode("#fff")
        let colorHexColorCodeNoHashSymbol = APIParameterTypes.Color.hexColorCode("ffffff")
        let colorHexColorCodeIsLong = APIParameterTypes.Color.hexColorCode("#fffffff")
        let colorHexColorCodeIsShort = APIParameterTypes.Color.hexColorCode("#ff")

        XCTAssertNotNil(colorHexColorCode_ffffff)
        XCTAssert(colorHexColorCode_ffffff!.name == "color")
        XCTAssert(colorHexColorCode_ffffff!.value == "#ffffff")
        XCTAssertNotNil(colorHexColorCode_fff)
        XCTAssert(colorHexColorCode_fff!.name == "color")
        XCTAssert(colorHexColorCode_fff!.value == "#fff")
        XCTAssertNil(colorHexColorCodeNoHashSymbol)
        XCTAssertNil(colorHexColorCodeIsLong)
        XCTAssertNil(colorHexColorCodeIsShort)
    }

    func testColorWithRawValue() {
        let colorWithSupportedColorName = APIParameterTypes.Color(rawValue: "red")
        let colorWithUnsupportedColorName = APIParameterTypes.Color(rawValue: "purple")
        let colorWithValidHexColorCode = APIParameterTypes.Color(rawValue: "#000000")
        let colorWithInvalidHexColorCode = APIParameterTypes.Color(rawValue: "000000")

        XCTAssertNotNil(colorWithSupportedColorName)
        XCTAssert(colorWithSupportedColorName!.name == "color")
        XCTAssert(colorWithSupportedColorName!.value == "red")
        XCTAssertNil(colorWithUnsupportedColorName)
        XCTAssertNotNil(colorWithValidHexColorCode)
        XCTAssert(colorWithValidHexColorCode!.name == "color")
        XCTAssert(colorWithValidHexColorCode!.value == "#000000")
        XCTAssertNil(colorWithInvalidHexColorCode)
    }

    func testColorWithEmptyHexColorCode() {
        let colorWithEmptyHexColorCode = APIParameterTypes.Color.hexColorCode("")

        XCTAssertNil(colorWithEmptyHexColorCode)
    }

    func testLocale() {
        let localeKoKR = APIParameterTypes.Locale.koKR

        XCTAssert(localeKoKR.name == "locale")
        XCTAssert(localeKoKR.value == "ko-KR")
    }

    func testPage() {
        let page1 = APIParameterTypes.Page(1)
        let pageUnderMin = APIParameterTypes.Page(0) // Min: 1

        XCTAssertNotNil(page1)
        XCTAssert(page1!.name == "page")
        XCTAssert(page1!.value == "1")
        XCTAssert(page1!.rawValue == 1)
        XCTAssertNil(pageUnderMin)
    }

    func testPageWithRawValue() {
        let page2 = APIParameterTypes.Page(rawValue: 2)

        XCTAssertNotNil(page2)
        XCTAssert(page2!.name == "page")
        XCTAssert(page2!.value == "2")
        XCTAssert(page2!.rawValue == 2)
    }

    func testPerPage() {
        let perPage50 = APIParameterTypes.PerPage(50)
        let perPageUnderMin = APIParameterTypes.PerPage(0) // Min: 1
        let perPageOverMax = APIParameterTypes.PerPage(100) // Max: 80

        XCTAssertNotNil(perPage50)
        XCTAssert(perPage50!.name == "per_page")
        XCTAssert(perPage50!.value == "50")
        XCTAssert(perPage50!.rawValue == 50)
        XCTAssertNil(perPageUnderMin)
        XCTAssertNil(perPageOverMax)
    }

    func testPerPageWithRawValue() {
        let perPage1 = APIParameterTypes.PerPage(rawValue: 1)

        XCTAssertNotNil(perPage1)
        XCTAssert(perPage1!.name == "per_page")
        XCTAssert(perPage1!.value == "1")
        XCTAssert(perPage1!.rawValue == 1)
    }
}
