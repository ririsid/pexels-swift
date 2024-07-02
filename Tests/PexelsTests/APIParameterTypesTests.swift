import XCTest
@testable import Pexels

final class APIParameterTypesTests: XCTestCase {
    func testQuery() {
        let queryNature = APIParameterTypes.Query("nature")
        let queryWithEmptyValue = APIParameterTypes.Query("")

        XCTAssertNotNil(queryNature)
        XCTAssert(queryNature!.name == "query")
        XCTAssert(queryNature!.value == "nature")
        XCTAssertNil(queryWithEmptyValue)
    }

    func testQueryWithRawValue() {
        let queryNature = APIParameterTypes.Query(rawValue: "nature")
        let queryWithEmptyValue = APIParameterTypes.Query(rawValue: "")

        XCTAssertNotNil(queryNature)
        XCTAssert(queryNature!.name == "query")
        XCTAssert(queryNature!.value == "nature")
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
        let colorWithEmptyHexColorCode = APIParameterTypes.Color.hexColorCode("")

        XCTAssertNotNil(colorHexColorCode_ffffff)
        XCTAssert(colorHexColorCode_ffffff!.name == "color")
        XCTAssert(colorHexColorCode_ffffff!.value == "#ffffff")
        XCTAssertNotNil(colorHexColorCode_fff)
        XCTAssert(colorHexColorCode_fff!.name == "color")
        XCTAssert(colorHexColorCode_fff!.value == "#fff")
        XCTAssertNil(colorHexColorCodeNoHashSymbol)
        XCTAssertNil(colorHexColorCodeIsLong)
        XCTAssertNil(colorHexColorCodeIsShort)
        XCTAssertNil(colorWithEmptyHexColorCode)
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
        let pageUnderMin = APIParameterTypes.Page(rawValue: 0)

        XCTAssertNotNil(page2)
        XCTAssert(page2!.name == "page")
        XCTAssert(page2!.value == "2")
        XCTAssert(page2!.rawValue == 2)
        XCTAssertNil(pageUnderMin)
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
        let perPageUnderMin = APIParameterTypes.PerPage(rawValue: 0) // Min: 1

        XCTAssertNotNil(perPage1)
        XCTAssert(perPage1!.name == "per_page")
        XCTAssert(perPage1!.value == "1")
        XCTAssert(perPage1!.rawValue == 1)
        XCTAssertNil(perPageUnderMin)
    }

    func testMinWidth() {
        let minWidth1024 = APIParameterTypes.MinWidth(1024)
        let minWidthNegative = APIParameterTypes.MinWidth(-1)

        XCTAssertNotNil(minWidth1024)
        XCTAssert(minWidth1024!.name == "min_width")
        XCTAssert(minWidth1024!.value == "1024")
        XCTAssert(minWidth1024!.rawValue == 1024)
        XCTAssertNil(minWidthNegative)
    }

    func testMinWidthWithRawValue() {
        let minWidth1024 = APIParameterTypes.MinWidth(rawValue: 1024)
        let minWidthNegative = APIParameterTypes.MinWidth(rawValue: -1)

        XCTAssertNotNil(minWidth1024)
        XCTAssert(minWidth1024!.name == "min_width")
        XCTAssert(minWidth1024!.value == "1024")
        XCTAssert(minWidth1024!.rawValue == 1024)
        XCTAssertNil(minWidthNegative)
    }

    func testMinHeight() {
        let minHeight1024 = APIParameterTypes.MinHeight(1024)
        let minHeightNegative = APIParameterTypes.MinHeight(-1)

        XCTAssertNotNil(minHeight1024)
        XCTAssert(minHeight1024!.name == "min_height")
        XCTAssert(minHeight1024!.value == "1024")
        XCTAssert(minHeight1024!.rawValue == 1024)
        XCTAssertNil(minHeightNegative)
    }

    func testMinHeightWithRawValue() {
        let minHeight1024 = APIParameterTypes.MinHeight(rawValue: 1024)
        let minHeightNegative = APIParameterTypes.MinHeight(rawValue: -1)

        XCTAssertNotNil(minHeight1024)
        XCTAssert(minHeight1024!.name == "min_height")
        XCTAssert(minHeight1024!.value == "1024")
        XCTAssert(minHeight1024!.rawValue == 1024)
        XCTAssertNil(minHeightNegative)
    }

    func testMinDuration() {
        let minDuration1 = APIParameterTypes.MinDuration(1)
        let minDurationNegative = APIParameterTypes.MinDuration(-1)

        XCTAssertNotNil(minDuration1)
        XCTAssert(minDuration1!.name == "min_duration")
        XCTAssert(minDuration1!.value == "1")
        XCTAssert(minDuration1!.rawValue == 1)
        XCTAssertNil(minDurationNegative)
    }

    func testMinDurationWithRawValue() {
        let minDuration1 = APIParameterTypes.MinDuration(rawValue: 1)
        let minDurationNegative = APIParameterTypes.MinDuration(rawValue: -1)

        XCTAssertNotNil(minDuration1)
        XCTAssert(minDuration1!.name == "min_duration")
        XCTAssert(minDuration1!.value == "1")
        XCTAssert(minDuration1!.rawValue == 1)
        XCTAssertNil(minDurationNegative)
    }

    func testMaxDuration() {
        let maxDuration60 = APIParameterTypes.MaxDuration(60)
        let maxDurationNegative = APIParameterTypes.MaxDuration(-1)

        XCTAssertNotNil(maxDuration60)
        XCTAssert(maxDuration60!.name == "max_duration")
        XCTAssert(maxDuration60!.value == "60")
        XCTAssert(maxDuration60!.rawValue == 60)
        XCTAssertNil(maxDurationNegative)
    }

    func testMaxDurationWithRawValue() {
        let maxDuration60 = APIParameterTypes.MaxDuration(rawValue: 60)
        let maxDurationNegative = APIParameterTypes.MaxDuration(rawValue: -1)

        XCTAssertNotNil(maxDuration60)
        XCTAssert(maxDuration60!.name == "max_duration")
        XCTAssert(maxDuration60!.value == "60")
        XCTAssert(maxDuration60!.rawValue == 60)
        XCTAssertNil(maxDurationNegative)
    }
}
