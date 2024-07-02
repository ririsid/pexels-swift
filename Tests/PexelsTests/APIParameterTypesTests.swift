import XCTest
@testable import Pexels

final class APIParameterTypesTests: XCTestCase {
    func testQuery() {
        let queryNature = APIParameterTypes.Query("nature")
        let queryWithEmptyValue = APIParameterTypes.Query("")

        XCTAssertNotNil(queryNature)
        XCTAssertEqual(queryNature!.name, "query")
        XCTAssertEqual(queryNature!.value, "nature")
        XCTAssertNil(queryWithEmptyValue)
    }

    func testQueryWithRawValue() {
        let queryNature = APIParameterTypes.Query(rawValue: "nature")
        let queryWithEmptyValue = APIParameterTypes.Query(rawValue: "")

        XCTAssertNotNil(queryNature)
        XCTAssertEqual(queryNature!.name, "query")
        XCTAssertEqual(queryNature!.value, "nature")
        XCTAssertNil(queryWithEmptyValue)
    }

    func testOrientation() {
        let orientationLandscape = APIParameterTypes.Orientation.landscape

        XCTAssertEqual(orientationLandscape.name, "orientation")
        XCTAssertEqual(orientationLandscape.value, "landscape")
    }

    func testSize() {
        let sizeLarge = APIParameterTypes.Size.large

        XCTAssertEqual(sizeLarge.name, "size")
        XCTAssertEqual(sizeLarge.value, "large")
    }

    func testColor() {
        let colorRed = APIParameterTypes.Color.red

        XCTAssertEqual(colorRed.name, "color")
        XCTAssertEqual(colorRed.value, "red")
    }

    func testColorWithHexColorCode() {
        let colorHexColorCode_ffffff = APIParameterTypes.Color.hexColorCode("#ffffff")
        let colorHexColorCode_fff = APIParameterTypes.Color.hexColorCode("#fff")
        let colorHexColorCodeNoHashSymbol = APIParameterTypes.Color.hexColorCode("ffffff")
        let colorHexColorCodeIsLong = APIParameterTypes.Color.hexColorCode("#fffffff")
        let colorHexColorCodeIsShort = APIParameterTypes.Color.hexColorCode("#ff")
        let colorWithEmptyHexColorCode = APIParameterTypes.Color.hexColorCode("")

        XCTAssertNotNil(colorHexColorCode_ffffff)
        XCTAssertEqual(colorHexColorCode_ffffff!.name, "color")
        XCTAssertEqual(colorHexColorCode_ffffff!.value, "#ffffff")
        XCTAssertNotNil(colorHexColorCode_fff)
        XCTAssertEqual(colorHexColorCode_fff!.name, "color")
        XCTAssertEqual(colorHexColorCode_fff!.value, "#fff")
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
        XCTAssertEqual(colorWithSupportedColorName!.name, "color")
        XCTAssertEqual(colorWithSupportedColorName!.value, "red")
        XCTAssertNil(colorWithUnsupportedColorName)
        XCTAssertNotNil(colorWithValidHexColorCode)
        XCTAssertEqual(colorWithValidHexColorCode!.name, "color")
        XCTAssertEqual(colorWithValidHexColorCode!.value, "#000000")
        XCTAssertNil(colorWithInvalidHexColorCode)
    }

    func testLocale() {
        let localeKoKR = APIParameterTypes.Locale.koKR

        XCTAssertEqual(localeKoKR.name, "locale")
        XCTAssertEqual(localeKoKR.value, "ko-KR")
    }

    func testPage() {
        let page1 = APIParameterTypes.Page(1)
        let pageUnderMin = APIParameterTypes.Page(0) // Min: 1

        XCTAssertNotNil(page1)
        XCTAssertEqual(page1!.name, "page")
        XCTAssertEqual(page1!.value, "1")
        XCTAssertEqual(page1!.rawValue, 1)
        XCTAssertNil(pageUnderMin)
    }

    func testPageWithRawValue() {
        let page2 = APIParameterTypes.Page(rawValue: 2)
        let pageUnderMin = APIParameterTypes.Page(rawValue: 0)

        XCTAssertNotNil(page2)
        XCTAssertEqual(page2!.name, "page")
        XCTAssertEqual(page2!.value, "2")
        XCTAssertEqual(page2!.rawValue, 2)
        XCTAssertNil(pageUnderMin)
    }

    func testPerPage() {
        let perPage50 = APIParameterTypes.PerPage(50)
        let perPageUnderMin = APIParameterTypes.PerPage(0) // Min: 1
        let perPageOverMax = APIParameterTypes.PerPage(100) // Max: 80

        XCTAssertNotNil(perPage50)
        XCTAssertEqual(perPage50!.name, "per_page")
        XCTAssertEqual(perPage50!.value, "50")
        XCTAssertEqual(perPage50!.rawValue, 50)
        XCTAssertNil(perPageUnderMin)
        XCTAssertNil(perPageOverMax)
    }

    func testPerPageWithRawValue() {
        let perPage1 = APIParameterTypes.PerPage(rawValue: 1)
        let perPageUnderMin = APIParameterTypes.PerPage(rawValue: 0) // Min: 1

        XCTAssertNotNil(perPage1)
        XCTAssertEqual(perPage1!.name, "per_page")
        XCTAssertEqual(perPage1!.value, "1")
        XCTAssertEqual(perPage1!.rawValue, 1)
        XCTAssertNil(perPageUnderMin)
    }

    func testMinWidth() {
        let minWidth1024 = APIParameterTypes.MinWidth(1024)
        let minWidthNegative = APIParameterTypes.MinWidth(-1)

        XCTAssertNotNil(minWidth1024)
        XCTAssertEqual(minWidth1024!.name, "min_width")
        XCTAssertEqual(minWidth1024!.value, "1024")
        XCTAssertEqual(minWidth1024!.rawValue, 1024)
        XCTAssertNil(minWidthNegative)
    }

    func testMinWidthWithRawValue() {
        let minWidth1024 = APIParameterTypes.MinWidth(rawValue: 1024)
        let minWidthNegative = APIParameterTypes.MinWidth(rawValue: -1)

        XCTAssertNotNil(minWidth1024)
        XCTAssertEqual(minWidth1024!.name, "min_width")
        XCTAssertEqual(minWidth1024!.value, "1024")
        XCTAssertEqual(minWidth1024!.rawValue, 1024)
        XCTAssertNil(minWidthNegative)
    }

    func testMinHeight() {
        let minHeight1024 = APIParameterTypes.MinHeight(1024)
        let minHeightNegative = APIParameterTypes.MinHeight(-1)

        XCTAssertNotNil(minHeight1024)
        XCTAssertEqual(minHeight1024!.name, "min_height")
        XCTAssertEqual(minHeight1024!.value, "1024")
        XCTAssertEqual(minHeight1024!.rawValue, 1024)
        XCTAssertNil(minHeightNegative)
    }

    func testMinHeightWithRawValue() {
        let minHeight1024 = APIParameterTypes.MinHeight(rawValue: 1024)
        let minHeightNegative = APIParameterTypes.MinHeight(rawValue: -1)

        XCTAssertNotNil(minHeight1024)
        XCTAssertEqual(minHeight1024!.name, "min_height")
        XCTAssertEqual(minHeight1024!.value, "1024")
        XCTAssertEqual(minHeight1024!.rawValue, 1024)
        XCTAssertNil(minHeightNegative)
    }

    func testMinDuration() {
        let minDuration1 = APIParameterTypes.MinDuration(1)
        let minDurationNegative = APIParameterTypes.MinDuration(-1)

        XCTAssertNotNil(minDuration1)
        XCTAssertEqual(minDuration1!.name, "min_duration")
        XCTAssertEqual(minDuration1!.value, "1")
        XCTAssertEqual(minDuration1!.rawValue, 1)
        XCTAssertNil(minDurationNegative)
    }

    func testMinDurationWithRawValue() {
        let minDuration1 = APIParameterTypes.MinDuration(rawValue: 1)
        let minDurationNegative = APIParameterTypes.MinDuration(rawValue: -1)

        XCTAssertNotNil(minDuration1)
        XCTAssertEqual(minDuration1!.name, "min_duration")
        XCTAssertEqual(minDuration1!.value, "1")
        XCTAssertEqual(minDuration1!.rawValue, 1)
        XCTAssertNil(minDurationNegative)
    }

    func testMaxDuration() {
        let maxDuration60 = APIParameterTypes.MaxDuration(60)
        let maxDurationNegative = APIParameterTypes.MaxDuration(-1)

        XCTAssertNotNil(maxDuration60)
        XCTAssertEqual(maxDuration60!.name, "max_duration")
        XCTAssertEqual(maxDuration60!.value, "60")
        XCTAssertEqual(maxDuration60!.rawValue, 60)
        XCTAssertNil(maxDurationNegative)
    }

    func testMaxDurationWithRawValue() {
        let maxDuration60 = APIParameterTypes.MaxDuration(rawValue: 60)
        let maxDurationNegative = APIParameterTypes.MaxDuration(rawValue: -1)

        XCTAssertNotNil(maxDuration60)
        XCTAssertEqual(maxDuration60!.name, "max_duration")
        XCTAssertEqual(maxDuration60!.value, "60")
        XCTAssertEqual(maxDuration60!.rawValue, 60)
        XCTAssertNil(maxDurationNegative)
    }
}
