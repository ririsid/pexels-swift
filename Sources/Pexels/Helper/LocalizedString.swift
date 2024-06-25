import Foundation

/// Returns a localized string from a table that Xcode generates for you when exporting localizations.
///
/// - Parameters:
///   - key: The key for a string in the specified table.
///   - arguments: The remaining argument values are substituted.
///   - tableName: The name of the table containing the key-value pairs. Also, the suffix for the strings file (a file with the `.strings` extension) to store the localized string. This defaults to the table in `Localizable.strings` when tableName is nil or an empty string.
///   - bundle: The bundle containing the table’s strings file. The main bundle is used if one isn’t specified.
///   - comment: The comment to place above the key-value pair in the strings file. This parameter provides the translator with some context about the localized string’s presentation to the user.
/// - Returns: Returns a localized version of the string designated by the specified key and residing in the specified table.
public func LocalizedString(_ key: String, _ arguments: any CVarArg..., tableName: String? = nil, bundle: Bundle = Bundle.main, comment: String) -> String {
    let format = NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: comment)
    return String.localizedStringWithFormat(format, arguments)
}
