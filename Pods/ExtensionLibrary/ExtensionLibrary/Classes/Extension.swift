//
//  Extensions.swift
//
//
//  Created by waitwalker on 2021/1/30.
//

import Foundation
import UIKit

/// 颜色扩展类
public extension UIColor {
    
    /// 随机颜色
    static var random: UIColor {
        let max = CGFloat(UInt32.max)
        let red = CGFloat(arc4random()) / max
        let green = CGFloat(arc4random()) / max
        let blue = CGFloat(arc4random()) / max

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 16进制初始化颜色
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 字符串形式 16进制初始化颜色
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

    /// 颜色的16进制值
    var hexValue: String {
        var color = self
        if color.cgColor.numberOfComponents < 4 {
            let c = color.cgColor.components!
            color = UIColor(red: c[0], green: c[0], blue: c[0], alpha: c[1])
        }
        if color.cgColor.colorSpace!.model != .rgb {
            return "#FFFFFF"
        }
        let c = color.cgColor.components!
        return String(format: "#%02X%02X%02X", Int(c[0]*255.0), Int(c[1]*255.0), Int(c[2]*255.0))
    }
}

/// 按钮位置枚举
public enum MTTButtonImagePostion {
    case Top
    case Left
    case Bottom
    case Right
}
/// 按钮扩展类
public extension UIButton {
    

    /// 按钮设置图片位置
    func imageWithPosition(_ postion: MTTButtonImagePostion, spacing: CGFloat) -> Void {
        self.setTitle(self.currentTitle, for: UIControlState.normal)
        self.setImage(self.currentImage, for: UIControlState.normal)
        
        let imageWidth = self.imageView?.image?.size.width
        let imageHeight = self.imageView?.image?.size.height
        
        let titleLabelTitle:NSString = (self.titleLabel?.text! as NSString?)!
        let labelWidth = titleLabelTitle.size(withAttributes: [NSAttributedStringKey.font : self.titleLabel?.font as Any]).width
        let labelHeight = titleLabelTitle.size(withAttributes: [NSAttributedStringKey.font : self.titleLabel?.font as Any]).height
        
        let imageOffsetX = (imageWidth! + labelWidth) / 2 - imageWidth! / 2 //image中心移动的x距离
        let imageOffsetY = imageHeight! / 2 + spacing / 2 //image中心移动的y距离
        let labelOffsetX = (imageWidth! + labelWidth / 2) - (imageWidth! + labelWidth) / 2 //label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + spacing / 2 //label中心移动的y距离
        
        let tempWidth = max(labelWidth, labelWidth)
        let changedWidth = labelWidth + imageWidth! - tempWidth;
        let tempHeight = max(labelHeight, imageHeight!)
        let changedHeight = labelHeight + imageHeight! + spacing - tempHeight
        
        switch postion {
            case MTTButtonImagePostion.Left:
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
                self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break
        case MTTButtonImagePostion.Right:
                self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth! + spacing/2), 0, imageWidth! + spacing/2);
                self.contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break
        case MTTButtonImagePostion.Top:
                self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
                self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
                self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break
        case MTTButtonImagePostion.Bottom:
                self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
                self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
                self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break
        }
    }
    
    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}


// MARK: - String拓展
public extension String {
    /// 截取字符串
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    func curString(from: Int, to: Int) -> String {
           let startIndex = self.index(self.startIndex, offsetBy: from)
           let endIndex = self.index(self.startIndex, offsetBy: to)
           return String(self[startIndex..<endIndex])
        }
    
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - rectSize: 容器的尺寸
    ///   - fontSize: 字体
    /// - Returns: 尺寸
    func getStringSize(text: String, rectSize: CGSize,fontSize: CGFloat) -> CGSize {
        let str = text as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        return rect.size
    }
    
    /// 输入字符串 输出数组
    /// e.g  "qwert" -> ["q","w","e","r","t"]
    /// - Returns: ["q","w","e","r","t"]
    func stringToArray() -> [String] {
        let num = count
        if !(num > 0) { return [""] }
        var arr: [String] = []
        for i in 0..<num {
            let tempStr: String = self[self.index(self.startIndex, offsetBy: i)].description
            arr.append(tempStr)
        }
        return arr
    }
    
    /// 字符URL格式化
    ///
    /// - Returns: 格式化的 url
    func stringEncoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url!
    }
    
    static func contentsOfFileWithResourceName(_ name: String, ofType type: String, fromBundle bundle: Bundle, encoding: String.Encoding, error: NSErrorPointer) -> String? {
        if let path = bundle.path(forResource: name, ofType: type) {
            do {
                return try String(contentsOfFile: path, encoding: encoding)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func startsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                  options: NSString.CompareOptions.anchored) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    
    func endsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                  options: [NSString.CompareOptions.anchored, NSString.CompareOptions.backwards]) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    
    func escape() -> String {
        let raw: NSString = self as NSString
        let allowedEscapes = CharacterSet(charactersIn: ":/?&=;+!@#$()',*")
        let str = raw.addingPercentEncoding(withAllowedCharacters: allowedEscapes)
        return (str as String?)!
    }
    
    func unescape() -> String {
        return CFURLCreateStringByReplacingPercentEscapes(
            kCFAllocatorDefault,
            self as CFString,
            "[]." as CFString) as String
    }
    
    private var stringWithAdditionalEscaping: String {
        return self.replacingOccurrences(of: "|", with: "%7C", options: NSString.CompareOptions(), range: nil)
    }
    
    var asURL: URL? {
        // Firefox and NSURL disagree about the valid contents of a URL.
        // Let's escape | for them.
        // We'd love to use one of the more sophisticated CFURL* or NSString.* functions, but
        // none seem to be quite suitable.
        return URL(string: self) ??
            URL(string: self.stringWithAdditionalEscaping)
    }
    
    /// Returns a new string made by removing the leading String characters contained
    /// in a given character set.
    func stringByTrimmingLeadingCharactersInSet(_ set: CharacterSet) -> String {
        var trimmed = self
        while trimmed.rangeOfCharacter(from: set)?.lowerBound == trimmed.startIndex {
            trimmed.remove(at: trimmed.startIndex)
        }
        return trimmed
    }
    
    /// Adds a newline at the closest space from the middle of a string.
    /// Example turning "Mark as Read" into "Mark as\n Read"
    func stringSplitWithNewline() -> String {
        let mid = self.count/2
        
        let arr: [Int] = self.indices.compactMap {
            if self[$0] == " " {
                return self.distance(from: startIndex, to: $0)
            }
            
            return nil
        }
        guard let closest = arr.enumerated().min(by: { abs($0.1 - mid) < abs($1.1 - mid) }) else {
            return self
        }
        var newString = self
        newString.insert("\n", at: newString.index(newString.startIndex, offsetBy: closest.element))
        return newString
    }
    
    func calculateTextHeight(text:String) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 5
        let font = UIFont.systemFont(ofSize: 14)
        attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
        attributeString.addAttribute(NSAttributedStringKey.font, value: font, range: NSMakeRange(0, text.count))
        let options = UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)
        let rect = attributeString.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.width - 60 - 20, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(options)), context: nil)
        return rect.size.height
    }
}


private struct ETLDEntry: CustomStringConvertible {
    let entry: String

    var isNormal: Bool { return isWild || !isException }
    var isWild: Bool = false
    var isException: Bool = false

    init(entry: String) {
        self.entry = entry
        self.isWild = entry.hasPrefix("*")
        self.isException = entry.hasPrefix("!")
    }

    fileprivate var description: String {
        return "{ Entry: \(entry), isWildcard: \(isWild), isException: \(isException) }"
    }
}

private typealias TLDEntryMap = [String: ETLDEntry]

private func loadEntriesFromDisk() -> TLDEntryMap? {
    if let data = String.contentsOfFileWithResourceName("effective_tld_names", ofType: "dat", fromBundle: Bundle(identifier: "org.mozilla.Shared")!, encoding: .utf8, error: nil) {
        let lines = data.components(separatedBy: "\n")
        let trimmedLines = lines.filter { !$0.hasPrefix("//") && $0 != "\n" && $0 != "" }

        var entries = TLDEntryMap()
        for line in trimmedLines {
            let entry = ETLDEntry(entry: line)
            let key: String
            if entry.isWild {
                // Trim off the '*.' part of the line
                key = line.curString(from: 0, to: 2)
            } else if entry.isException {
                // Trim off the '!' part of the line
                key = line.curString(from: 0, to: 1)
            } else {
                key = line
            }
            entries[key] = entry
        }
        return entries
    }
    return nil
}

private var etldEntries: TLDEntryMap? = {
    return loadEntriesFromDisk()
}()

// MARK: - Local Resource URL Extensions
extension URL {

    public func allocatedFileSize() -> Int64 {
        // First try to get the total allocated size and in failing that, get the file allocated size
        return getResourceLongLongForKey(URLResourceKey.totalFileAllocatedSizeKey.rawValue)
            ?? getResourceLongLongForKey(URLResourceKey.fileAllocatedSizeKey.rawValue)
            ?? 0
    }

    public func getResourceValueForKey(_ key: String) -> Any? {
        let resourceKey = URLResourceKey(key)
        let keySet = Set<URLResourceKey>([resourceKey])

        var val: Any?
        do {
            let values = try resourceValues(forKeys: keySet)
            val = values.allValues[resourceKey]
        } catch _ {
            return nil
        }
        return val
    }

    public func getResourceLongLongForKey(_ key: String) -> Int64? {
        return (getResourceValueForKey(key) as? NSNumber)?.int64Value
    }

    public func getResourceBoolForKey(_ key: String) -> Bool? {
        return getResourceValueForKey(key) as? Bool
    }

    public var isRegularFile: Bool {
        return getResourceBoolForKey(URLResourceKey.isRegularFileKey.rawValue) ?? false
    }

    public func lastComponentIsPrefixedBy(_ prefix: String) -> Bool {
        return (pathComponents.last?.hasPrefix(prefix) ?? false)
    }
}

// The list of permanent URI schemes has been taken from http://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml
private let permanentURISchemes = ["aaa", "aaas", "about", "acap", "acct", "cap", "cid", "coap", "coaps", "crid", "data", "dav", "dict", "dns", "example", "file", "ftp", "geo", "go", "gopher", "h323", "http", "https", "iax", "icap", "im", "imap", "info", "ipp", "ipps", "iris", "iris.beep", "iris.lwz", "iris.xpc", "iris.xpcs", "jabber", "ldap", "mailto", "mid", "msrp", "msrps", "mtqp", "mupdate", "news", "nfs", "ni", "nih", "nntp", "opaquelocktoken", "pkcs11", "pop", "pres", "reload", "rtsp", "rtsps", "rtspu", "service", "session", "shttp", "sieve", "sip", "sips", "sms", "snmp", "soap.beep", "soap.beeps", "stun", "stuns", "tag", "tel", "telnet", "tftp", "thismessage", "tip", "tn3270", "turn", "turns", "tv", "urn", "vemmi", "vnc", "ws", "wss", "xcon", "xcon-userid", "xmlrpc.beep", "xmlrpc.beeps", "xmpp", "z39.50r", "z39.50s"]

extension URL {

    public func withQueryParams(_ params: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var items = (components.queryItems ?? [])
        for param in params {
            items.append(param)
        }
        components.queryItems = items
        return components.url!
    }

    public func withQueryParam(_ name: String, value: String) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        let item = URLQueryItem(name: name, value: value)
        components.queryItems = (components.queryItems ?? []) + [item]
        return components.url!
    }

    public func getQuery() -> [String: String] {
        var results = [String: String]()
        let keyValues = self.query?.components(separatedBy: "&")

        if keyValues?.count ?? 0 > 0 {
            for pair in keyValues! {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results[kv[0]] = kv[1]
                }
            }
        }

        return results
    }

    public var hostPort: String? {
        if let host = self.host {
            if let port = (self as NSURL).port?.int32Value {
                return "\(host):\(port)"
            }
            return host
        }
        return nil
    }

    public var origin: String? {
        guard isWebPage(includeDataURIs: false), let hostPort = self.hostPort, let scheme = scheme else {
            return nil
        }
        return "\(scheme)://\(hostPort)"
    }

    /**
     * Returns the second level domain (SLD) of a url. It removes any subdomain/TLD
     *
     * E.g., https://m.foo.com/bar/baz?noo=abc#123  => foo
     **/
    public var hostSLD: String {
        guard let publicSuffix = self.publicSuffix, let baseDomain = self.baseDomain else {
            return self.normalizedHost ?? self.absoluteString
        }
        return baseDomain.replacingOccurrences(of: ".\(publicSuffix)", with: "")
    }

    public var normalizedHostAndPath: String? {
        return normalizedHost.flatMap { $0 + self.path }
    }

    public var absoluteDisplayString: String {
        var urlString = self.absoluteString
        // For http URLs, get rid of the trailing slash if the path is empty or '/'
        if (self.scheme == "http" || self.scheme == "https") && (self.path == "/") && urlString.hasSuffix("/") {
            urlString = urlString.curString(from: 0, to: urlString.count - 1)
        }
        // If it's basic http, strip out the string but leave anything else in
        if urlString.hasPrefix("http://") {
            return urlString.curString(from: 7, to: urlString.count - 1)
        } else {
            return urlString
        }
    }

    /// String suitable for displaying outside of the app, for example in notifications, were Data Detectors will
    /// linkify the text and make it into a openable-in-Safari link.
    public var absoluteDisplayExternalString: String {
        return self.absoluteDisplayString.replacingOccurrences(of: ".", with: "\u{2024}")
    }

    public var displayURL: URL? {
        if self.isReaderModeURL {
            return self.decodeReaderModeURL?.havingRemovedAuthorisationComponents()
        }

        if self.isErrorPageURL {
            return originalURLFromErrorURL?.displayURL
        }

        if !self.isAboutURL {
            return self.havingRemovedAuthorisationComponents()
        }

        return nil
    }

    /**
    Returns the base domain from a given hostname. The base domain name is defined as the public domain suffix
    with the base private domain attached to the front. For example, for the URL www.bbc.co.uk, the base domain
    would be bbc.co.uk. The base domain includes the public suffix (co.uk) + one level down (bbc).
    :returns: The base domain string for the given host name.
    */
    public var baseDomain: String? {
        guard !isIPv6, let host = host else { return nil }

        // If this is just a hostname and not a FQDN, use the entire hostname.
        if !host.contains(".") {
            return host
        }

        return publicSuffixFromHost(host, withAdditionalParts: 1)
    }

    /**
     * Returns just the domain, but with the same scheme, and a trailing '/'.
     *
     * E.g., https://m.foo.com/bar/baz?noo=abc#123  => https://foo.com/
     *
     * Any failure? Return this URL.
     */
    public var domainURL: URL {
        if let normalized = self.normalizedHost {
            // Use NSURLComponents instead of NSURL since the former correctly preserves
            // brackets for IPv6 hosts, whereas the latter escapes them.
            var components = URLComponents()
            components.scheme = self.scheme
            components.port = self.port
            components.host = normalized
            components.path = "/"
            return components.url ?? self
        }
        return self
    }

    public var normalizedHost: String? {
        // Use components.host instead of self.host since the former correctly preserves
        // brackets for IPv6 hosts, whereas the latter strips them.
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), var host = components.host, host != "" else {
            return nil
        }

        if let range = host.range(of: "^(www|mobile|m)\\.", options: .regularExpression) {
            host.replaceSubrange(range, with: "")
        }

        return host
    }

    /**
    Returns the public portion of the host name determined by the public suffix list found here: https://publicsuffix.org/list/.
    For example for the url www.bbc.co.uk, based on the entries in the TLD list, the public suffix would return co.uk.
    :returns: The public suffix for within the given hostname.
    */
    public var publicSuffix: String? {
        return host.flatMap { publicSuffixFromHost($0, withAdditionalParts: 0) }
    }

    public func isWebPage(includeDataURIs: Bool = true) -> Bool {
        let schemes = includeDataURIs ? ["http", "https", "data"] : ["http", "https"]
        return scheme.map { schemes.contains($0) } ?? false
    }

    // This helps find local urls that we do not want to show loading bars on.
    // These utility pages should be invisible to the user
    public var isLocalUtility: Bool {
        guard self.isLocal else {
            return false
        }
        let utilityURLs = ["/errors", "/about/sessionrestore", "/about/home", "/reader-mode"]
        return utilityURLs.contains { self.path.hasPrefix($0) }
    }

    public var isLocal: Bool {
        guard isWebPage(includeDataURIs: false) else {
            return false
        }
        // iOS forwards hostless URLs (e.g., http://:6571) to localhost.
        guard let host = host, !host.isEmpty else {
            return true
        }

        return host.lowercased() == "localhost" || host == "127.0.0.1"
    }

    public var isIPv6: Bool {
        return host?.contains(":") ?? false
    }
    
    /**
     Returns whether the URL's scheme is one of those listed on the official list of URI schemes.
     This only accepts permanent schemes: historical and provisional schemes are not accepted.
     */
    public var schemeIsValid: Bool {
        guard let scheme = scheme else { return false }
        return permanentURISchemes.contains(scheme.lowercased())
    }

    public func havingRemovedAuthorisationComponents() -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        urlComponents.user = nil
        urlComponents.password = nil
        if let url = urlComponents.url {
            return url
        }
        return self
    }
}

// Extensions to deal with ReaderMode URLs
extension URL {
    public var isReaderModeURL: Bool {
        let scheme = self.scheme, host = self.host, path = self.path
        return scheme == "http" && host == "localhost" && path == "/reader-mode/page"
    }

    public var decodeReaderModeURL: URL? {
        if self.isReaderModeURL {
            if let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems, queryItems.count == 1 {
                if let queryItem = queryItems.first, let value = queryItem.value {
                    return URL(string: value)
                }
            }
        }
        return nil
    }

    public func encodeReaderModeURL(_ baseReaderModeURL: String) -> URL? {
        if let encodedURL = absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            if let aboutReaderURL = URL(string: "\(baseReaderModeURL)?url=\(encodedURL)") {
                return aboutReaderURL
            }
        }
        return nil
    }
}

// Helpers to deal with ErrorPage URLs
extension URL {
    public var isErrorPageURL: Bool {
        if let host = self.host {
            return self.scheme == "http" && host == "localhost" && path == "/errors/error.html"
        }
        return false
    }

    public var originalURLFromErrorURL: URL? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        
        if components?.queryItems != nil {
            for item in (components?.queryItems)! {
                if item.name == "url" {
                    return URL(string: (components?.path)!)
                }
            }
        }
        return nil
    }
}

// Helpers to deal with About URLs
extension URL {
    public var isAboutHomeURL: Bool {
        if let urlString = self.getQuery()["url"]?.unescape(), isErrorPageURL {
            let url = URL(string: urlString) ?? self
            return url.aboutComponent == "home"
        }
        return self.aboutComponent == "home"
    }

    public var isAboutURL: Bool {
        return self.aboutComponent != nil
    }

    /// If the URI is an about: URI, return the path after "about/" in the URI.
    /// For example, return "home" for "http://localhost:1234/about/home/#panel=0".
    public var aboutComponent: String? {
        let aboutPath = "/about/"
        guard let scheme = self.scheme, let host = self.host else {
            return nil
        }
        if scheme == "http" && host == "localhost" && path.hasPrefix(aboutPath) {
            return path.curString(from: aboutPath.count - 1, to: path.count - 1)
        }
        return nil
    }

}

//MARK: Private Helpers
private extension URL {
    func publicSuffixFromHost( _ host: String, withAdditionalParts additionalPartCount: Int) -> String? {
        if host.isEmpty {
            return nil
        }

        // Check edge case where the host is either a single or double '.'.
        if host.isEmpty || NSString(string: host).lastPathComponent == "." {
            return ""
        }

        /**
        *  The following algorithm breaks apart the domain and checks each sub domain against the effective TLD
        *  entries from the effective_tld_names.dat file. It works like this:
        *
        *  Example Domain: test.bbc.co.uk
        *  TLD Entry: bbc
        *
        *  1. Start off by checking the current domain (test.bbc.co.uk)
        *  2. Also store the domain after the next dot (bbc.co.uk)
        *  3. If we find an entry that matches the current domain (test.bbc.co.uk), perform the following checks:
        *    i. If the domain is a wildcard AND the previous entry is not nil, then the current domain matches
        *       since it satisfies the wildcard requirement.
        *    ii. If the domain is normal (no wildcard) and we don't have anything after the next dot, then
        *        currentDomain is a valid TLD
        *    iii. If the entry we matched is an exception case, then the base domain is the part after the next dot
        *
        *  On the next run through the loop, we set the new domain to check as the part after the next dot,
        *  update the next dot reference to be the string after the new next dot, and check the TLD entries again.
        *  If we reach the end of the host (nextDot = nil) and we haven't found anything, then we've hit the
        *  top domain level so we use it by default.
        */

        let tokens = host.components(separatedBy: ".")
        let tokenCount = tokens.count
        var suffix: String?
        var previousDomain: String? = nil
        var currentDomain: String = host

        for offset in 0..<tokenCount {
            // Store the offset for use outside of this scope so we can add additional parts if needed
            let nextDot: String? = offset + 1 < tokenCount ? tokens[offset + 1..<tokenCount].joined(separator: ".") : nil

            if let entry = etldEntries?[currentDomain] {
                if entry.isWild && (previousDomain != nil) {
                    suffix = previousDomain
                    break
                } else if entry.isNormal || (nextDot == nil) {
                    suffix = currentDomain
                    break
                } else if entry.isException {
                    suffix = nextDot
                    break
                }
            }

            previousDomain = currentDomain
            if let nextDot = nextDot {
                currentDomain = nextDot
            } else {
                break
            }
        }

        var baseDomain: String?
        if additionalPartCount > 0 {
            if let suffix = suffix {
                // Take out the public suffixed and add in the additional parts we want.
                let literalFromEnd: NSString.CompareOptions = [.literal,        // Match the string exactly.
                                     .backwards,      // Search from the end.
                                     .anchored]         // Stick to the end.
                let suffixlessHost = host.replacingOccurrences(of: suffix, with: "", options: literalFromEnd, range: nil)
                let suffixlessTokens = suffixlessHost.components(separatedBy: ".").filter { $0 != "" }
                let maxAdditionalCount = max(0, suffixlessTokens.count - additionalPartCount)
                let additionalParts = suffixlessTokens[maxAdditionalCount..<suffixlessTokens.count]
                let partsString = additionalParts.joined(separator: ".")
                baseDomain = [partsString, suffix].joined(separator: ".")
            } else {
                return nil
            }
        } else {
            baseDomain = suffix
        }

        return baseDomain
    }
}


public let NSFileManagerExtensionsDomain = "cn.waitwalker.NSFileManagerExtensions"

public enum NSFileManagerExtensionsErrorCodes: Int {
    case enumeratorFailure = 0
    case enumeratorElementNotURL = 1
    case errorEnumeratingDirectory = 2
}

public extension FileManager {
    
    private func directoryEnumeratorForURL(_ url: URL) throws -> FileManager.DirectoryEnumerator {
        let prefetchedProperties = [
            URLResourceKey.isRegularFileKey,
            URLResourceKey.fileAllocatedSizeKey,
            URLResourceKey.totalFileAllocatedSizeKey
        ]
        
        // If we run into an issue getting an enumerator for the given URL, capture the error and bail out later.
        var enumeratorError: NSError?
        let errorHandler: (URL, Error) -> Bool = { _, error in
            enumeratorError = error as NSError
            return false
        }
        
        guard let directoryEnumerator = FileManager.default.enumerator(
            at: url, includingPropertiesForKeys: prefetchedProperties,
            options: [],
            errorHandler: errorHandler) else {
            throw errorWithCode(.enumeratorFailure)
        }
        
        // Bail out if we encountered an issue getting the enumerator.
        if let _ = enumeratorError {
            throw errorWithCode(.errorEnumeratingDirectory, underlyingError: enumeratorError)
        }
        
        return directoryEnumerator
    }
    
    private func sizeForItemURL(_ url: Any, withPrefix prefix: String) throws -> Int64 {
        guard let itemURL = url as? URL else {
            throw errorWithCode(.enumeratorElementNotURL)
        }
        
        // Skip files that are not regular and don't match our prefix
        guard itemURL.isRegularFile && itemURL.lastComponentIsPrefixedBy(prefix) else {
            return 0
        }
        
        return itemURL.allocatedFileSize()
    }
    
    func allocatedSizeOfDirectoryAtURL(_ url: URL, forFilesPrefixedWith prefix: String, isLargerThanBytes threshold: Int64) throws -> Bool {
        let directoryEnumerator = try directoryEnumeratorForURL(url)
        var acc: Int64 = 0
        for item in directoryEnumerator {
            acc += try sizeForItemURL(item as AnyObject, withPrefix: prefix)
            if acc > threshold {
                return true
            }
        }
        return false
    }
    
    /**
     Returns the precise size of the given directory on disk.
     
     - parameter url:    Directory URL
     - parameter prefix: Prefix of files to check for size
     
     - throws: Error reading/operating on disk.
     */
    func getAllocatedSizeOfDirectoryAtURL(_ url: URL, forFilesPrefixedWith prefix: String) throws -> Int64 {
        let directoryEnumerator = try directoryEnumeratorForURL(url)
        return try directoryEnumerator.reduce(0) {
            let size = try sizeForItemURL($1 as AnyObject, withPrefix: prefix)
            return $0 + size
        }
    }
    
    func contentsOfDirectoryAtPath(_ path: String, withFilenamePrefix prefix: String) throws -> [String] {
        return try FileManager.default.contentsOfDirectory(atPath: path)
            .filter { $0.hasPrefix("\(prefix).") }
            .sorted { $0 < $1 }
    }
    
    func removeItemInDirectory(_ directory: String, named: String) throws {
        let file = URL(fileURLWithPath: directory).appendingPathComponent(named).path
        try self.removeItem(atPath: file)
    }
    
    private func errorWithCode(_ code: NSFileManagerExtensionsErrorCodes, underlyingError error: NSError? = nil) -> NSError {
        var userInfo = [String: AnyObject]()
        if let _ = error {
            userInfo[NSUnderlyingErrorKey] = error
        }
        
        return NSError(
            domain: NSFileManagerExtensionsDomain,
            code: code.rawValue,
            userInfo: userInfo)
    }
}

/// 图片扩展
public extension UIImage {
    
    class func imageNamed(name:String) -> UIImage {
        let image = UIImage(named: name)
        return image!
    }
    
    
    /// 生成颜色图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 生成的图片
    class func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    /// 重置图片到希望的尺寸
    ///
    /// - Parameter exceptSize: 期望的尺寸
    /// - Returns: 重置后的图片
    func resetImageSize(exceptSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(exceptSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: exceptSize.width, height: exceptSize.height))
        let exceptImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return exceptImage
    }
    
    
    /// 等比例缩放图片
    ///
    /// - Parameter scale: 比例
    /// - Returns: 缩放后的图片
    func scaleImage(scale:CGFloat) -> UIImage {
        let scaledSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        return resetImageSize(exceptSize: scaledSize)
    }
    
    
    /// 图片按照指定宽度缩放
    ///
    /// - Parameters:
    ///   - expectWidth: 指定宽度
    ///   - sourceImage: 原图
    /// - Returns: 缩放后的图片
    func scaleImageWithWidth(expectWidth:CGFloat,sourceImage:UIImage) -> UIImage {
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth:CGFloat = expectWidth
        let targetHeight = height / (width / targetWidth)
        let size = CGSize(width: targetWidth, height: targetHeight)
        
        var scaleFactor:CGFloat = 0.0
        var scaleWidth = targetWidth
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0, y: 0)
        
        if __CGSizeEqualToSize(imageSize, size) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaleWidth = width * scaleFactor
            scaleHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5
            } else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(size)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        sourceImage.draw(in: thumbnailRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if newImage == nil {
            print("scale image failed")
        }
        UIGraphicsEndImageContext()
        return newImage!
    }
}

#if os(iOS) || os(tvOS)

public extension UIImage {
    
    /// EZSE: Returns base64 string
    var base64: String {
        return UIImageJPEGRepresentation(self, 1.0)!.base64EncodedString()
    }
    
    /// EZSE: Returns compressed image to rate from 0 to 1
    func compressImage(rate: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, rate)
    }

    /// EZSE: Returns Image size in Bytes
    func getSizeAsBytes() -> Int {
        return UIImageJPEGRepresentation(self, 1)?.count ?? 0
    }

    /// EZSE: Returns Image size in Kylobites
    func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }

    /// EZSE: scales image
    class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// EZSE Returns resized image with width. Might return low quality
    func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// EZSE Returns resized image with height. Might return low quality
    func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// EZSE:
    func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    /// EZSE:
    func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }

    /// EZSE: Returns cropped image from CGRect
    func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("EZSE: Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("EZSE: Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage
    }

    /// EZSE: Use current image for pattern of color
    func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()

        return newImage
    }

    ///EZSE: Returns the image associated with the URL
    convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            print("EZSE: No image in URL \(urlString)")
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }

    ///EZSE: Returns an empty image //TODO: Add to readme
    class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

#endif

#if os(iOS) || os(tvOS)

public extension UIImageView {
    
    /// EZSE: Convenince init that takes coordinates of bottom left corner, height width and image name.
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, imageName: String? = nil) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        if let name = imageName {
            self.image = UIImage(named: name)
        }
    }

    /// EZSE: Convenience init that takes coordinates of bottom left corner, image name and scales image frame to width.
    convenience init(x: CGFloat, y: CGFloat, imageName: String, scaleToWidth: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: 0, height: 0))
        image = UIImage(named: imageName)
        if image != nil {
            scaleImageFrameToWidth(width: scaleToWidth)
        } else {
            assertionFailure("EZSwiftExtensions Error: The imageName: '\(imageName)' is invalid!!!")
        }
    }

    /// EZSE: Convenience init that takes coordinates of bottom left corner, width height and an UIImage Object.
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, image: UIImage) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        self.image = image
    }

    /// EZSE: Convenience init that coordinates of bottom left corner, an UIImage object and scales image from to width.
    convenience init(x: CGFloat, y: CGFloat, image: UIImage, scaleToWidth: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: 0, height: 0))
        self.image = image
        scaleImageFrameToWidth(width: scaleToWidth)
    }

    /// EZSE: scales this ImageView size to fit the given width
    func scaleImageFrameToWidth(width: CGFloat) {
        guard let image = image else {
            print("EZSwiftExtensions Error: The image is not set yet!")
            return
        }
        let widthRatio = image.size.width / width
        let newWidth = image.size.width / widthRatio
        let newHeigth = image.size.height / widthRatio
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newWidth, height: newHeigth)
    }

    /// EZSE: scales this ImageView size to fit the given height
    func scaleImageFrameToHeight(height: CGFloat) {
        guard let image = image else {
            print("EZSwiftExtensions Error: The image is not set yet!")
            return
        }
        let heightRatio = image.size.height / height
        let newHeight = image.size.height / heightRatio
        let newWidth = image.size.width / heightRatio
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newWidth, height: newHeight)
    }

    /// EZSE: Rounds up an image by clipping the corner radius to one half the frame width.
    func roundSquareImage() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }

    /// EZSE: Initializes an UIImage from URL and adds into current ImageView
    func image(url: String) {
        ez.requestImage(url, success: { (image) -> Void in
            if let img = image {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        })
    }

    /// EZSE: Initializes an UIImage from URL and adds into current ImageView with placeholder
    func image(url: String, placeholder: UIImage) {
        self.image = placeholder
        image(url: url)
    }

    /// EZSE: Initializes an UIImage from URL and adds into current ImageView with placeholder
    func image(url: String, placeholderNamed: String) {
        if let image = UIImage(named: placeholderNamed) {
            self.image(url: url, placeholder: image)
        } else {
            image(url: url)
        }
    }
}

#endif


public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

extension Array {

    ///EZSE: Get a sub array from range of index
    public func get(at range: ClosedRange<Int>) -> Array {
        let halfOpenClampedRange = Range(range).clamped(to: Range(indices))
        return Array(self[halfOpenClampedRange])
    }

    /// EZSE: Checks if array contains at least 1 item which type is same with given element's type
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }

    /// EZSE: Decompose an array to a tuple with first element and the rest
    public func decompose() -> (head: Iterator.Element, tail: SubSequence)? {
        return (count > 0) ? (self[0], self[1..<count]) : nil
    }

    /// EZSE: Iterates on each element of the array with its index. (Index, Element)
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }

    /// EZSE: Gets the object at the specified index, if it exists.
    public func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }

    /// EZSE: Prepends an object to the array.
    public mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// EZSE: Returns a random element from the array.
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }

    /// EZSE: Reverse the given index. i.g.: reverseIndex(2) would be 2 to the last
    public func reverseIndex(_ index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }
        return Swift.max(count - 1 - index, 0)
    }

    /// EZSE: Shuffles the array in-place using the Fisher-Yates-Durstenfeld algorithm.
    public mutating func shuffle() {
        guard count > 1 else { return }
        var j: Int
        for i in 0..<(count-2) {
            j = Int(arc4random_uniform(UInt32(count - i)))
            if i != i+j { self.swapAt(i, i+j) }
        }
    }

    /// EZSE: Shuffles copied array using the Fisher-Yates-Durstenfeld algorithm, returns shuffled array.
    public func shuffled() -> Array {
        var result = self
        result.shuffle()
        return result
    }

    /// EZSE: Returns an array with the given number as the max number of elements.
    public func takeMax(_ n: Int) -> Array {
        return Array(self[0..<Swift.max(0, Swift.min(n, count))])
    }

    /// EZSE: Checks if test returns true for all the elements in self
    public func testAll(_ body: @escaping (Element) -> Bool) -> Bool {
        return !contains { !body($0) }
    }

    /// EZSE: Checks if all elements in the array are true or false
    public func testAll(is condition: Bool) -> Bool {
        return testAll { ($0 as? Bool) ?? !condition == condition }
    }
}

extension Array where Element: Equatable {

    /// EZSE: Checks if the main array contains the parameter array
    public func contains(_ array: [Element]) -> Bool {
        return array.testAll { self.index(of: $0) ?? -1 >= 0 }
    }

    /// EZSE: Checks if self contains a list of items.
    public func contains(_ elements: Element...) -> Bool {
        return elements.testAll { self.index(of: $0) ?? -1 >= 0 }
    }

    /// EZSE: Returns the indexes of the object
    public func indexes(of element: Element) -> [Int] {
        return enumerated().compactMap { ($0.element == element) ? $0.offset : nil }
    }

    /// EZSE: Returns the last index of the object
    public func lastIndex(of element: Element) -> Int? {
        return indexes(of: element).last
    }

    /// EZSE: Removes the first given object
    public mutating func removeFirst(_ element: Element) {
        guard let index = index(of: element) else { return }
        self.remove(at: index)
    }

    /// EZSE: Removes all occurrences of the given object(s), at least one entry is needed.
    public mutating func removeAll(_ firstElement: Element?, _ elements: Element...) {
        var removeAllArr = [Element]()
        
        if let firstElementVal = firstElement {
            removeAllArr.append(firstElementVal)
        }
        
        elements.forEach({element in removeAllArr.append(element)})
        
        removeAll(removeAllArr)
    }

    /// EZSE: Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elements.contains($0) }
    }

    /// EZSE: Difference of self and the input arrays.
    public func difference(_ values: [Element]...) -> [Element] {
        var result = [Element]()
        elements: for element in self {
            for value in values {
                //  if a value is in both self and one of the values arrays
                //  jump to the next iteration of the outer loop
                if value.contains(element) {
                    continue elements
                }
            }
            //  element it's only in self
            result.append(element)
        }
        return result
    }

    /// EZSE: Intersection of self and the input arrays.
    public func intersection(_ values: [Element]...) -> Array {
        var result = self
        var intersection = Array()

        for (i, value) in values.enumerated() {
            //  the intersection is computed by intersecting a couple per loop:
            //  self n values[0], (self n values[0]) n values[1], ...
            if i > 0 {
                result = intersection
                intersection = Array()
            }

            //  find common elements and save them in first set
            //  to intersect in the next loop
            value.forEach { (item: Element) -> Void in
                if result.contains(item) {
                    intersection.append(item)
                }
            }
        }
        return intersection
    }

    /// EZSE: Union of self and the input arrays.
    public func union(_ values: [Element]...) -> Array {
        var result = self
        for array in values {
            for value in array {
                if !result.contains(value) {
                    result.append(value)
                }
            }
        }
        return result
    }

    /// EZSE: Returns an array consisting of the unique elements in the array
    public func unique() -> Array {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}

extension Array where Element: Hashable {

    /// EZSE: Removes all occurrences of the given object(s)
    public mutating func removeAll(_ elements: [Element]) {
        let elementsSet = Set(elements)
        // COW ensures no extra copy in case of no removed elements
        self = filter { !elementsSet.contains($0) }
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Deprecated 1.8
extension Array {

    /// EZSE: Checks if array contains at least 1 instance of the given object type
    @available(*, deprecated, renamed: "containsType(of:)")
    public func containsInstanceOf<T>(_ element: T) -> Bool {
        return containsType(of: element)
    }

    /// EZSE: Gets the object at the specified index, if it exists.
    @available(*, deprecated, renamed: "get(at:)")
    public func get(_ index: Int) -> Element? {
        return get(at: index)
    }

    /// EZSE: Checks if all elements in the array are true of false
    @available(*, deprecated, renamed: "testAll(is:)")
    public func testIfAllIs(_ condition: Bool) -> Bool {
        return testAll(is: condition)
    }

}

extension Array where Element: Equatable {

    /// EZSE: Removes the first given object
    @available(*, deprecated, renamed: "removeFirst(_:)")
    public mutating func removeFirstObject(_ object: Element) {
        removeFirst(object)
    }
}

// MARK: - Deprecated 1.7
extension Array {

    /// EZSE: Prepends an object to the array.
    @available(*, deprecated, renamed: "insertFirst(_:)")
    public mutating func insertAsFirst(_ newElement: Element) {
        insertFirst(newElement)
    }

}

extension Array where Element: Equatable {

    /// EZSE: Checks if the main array contains the parameter array
    @available(*, deprecated, renamed: "contains(_:)")
    public func containsArray(_ array: [Element]) -> Bool {
        return contains(array)
    }

    /// EZSE: Returns the indexes of the object
    @available(*, deprecated, renamed: "indexes(of:)")
    public func indexesOf(_ object: Element) -> [Int] {
        return indexes(of: object)
    }

    /// EZSE: Returns the last index of the object
    @available(*, deprecated, renamed: "lastIndex(_:)")
    public func lastIndexOf(_ object: Element) -> Int? {
        return lastIndex(of: object)
    }

    /// EZSE: Removes the first given object
    @available(*, deprecated, renamed: "removeFirstObject(_:)")
    public mutating func removeObject(_ object: Element) {
        removeFirst(object)
    }

}

// MARK: - Deprecated 1.6
extension Array {

    /// EZSE: Creates an array with values generated by running each value of self
    /// through the mapFunction and discarding nil return values.
    @available(*, deprecated, renamed: "flatMap(_:)")
    public func mapFilter<V>(mapFunction map: (Element) -> (V)?) -> [V] {
        return compactMap { map($0) }
    }

    /// EZSE: Iterates on each element of the array with its index.  (Index, Element)
    @available(*, deprecated, renamed: "forEachEnumerated(_:)")
    public func each(_ call: @escaping (Int, Element) -> Void) {
        forEachEnumerated(call)
    }

}


#if os(iOS) || os(tvOS)

public extension CGFloat {

    /// EZSE: Return the central value of CGFloat.
    var center: CGFloat { return (self / 2) }

    @available(*, deprecated, renamed: "degreesToRadians")
    func toRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }

    /// EZSwiftExtensions
    func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }

    /// EZSwiftExtensions
    mutating func toRadiansInPlace() {
        self = (.pi * self) / 180.0
    }

    /// EZSE: Converts angle degrees to radians.
    static func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }

    /// EZSE: Converts radians to degrees.
    func radiansToDegrees() -> CGFloat {
        return (180.0 * self) / .pi
    }

    /// EZSE: Converts angle radians to degrees mutable version.
    mutating func toDegreesInPlace() {
        self = (180.0 * self) / .pi
    }

    /// EZSE : Converts angle radians to degrees static version.
    static func radiansToDegrees(_ angleInDegrees: CGFloat) -> CGFloat {
        return (180.0 * angleInDegrees) / .pi
    }

    /// EZSE: Returns a random floating point number between 0.0 and 1.0, inclusive.
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    /// EZSE: Returns a random floating point number in the range min...max, inclusive.
    static func random(within: Range<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }

    /// EZSE: Returns a random floating point number in the range min...max, inclusive.
    static func random(within: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }

    /**
      EZSE :Returns the shortest angle between two angles. The result is always between
      -π and π.
      Inspired from : https://github.com/raywenderlich/SKTUtils/blob/master/SKTUtils/CGFloat%2BExtensions.swift
     */
    static func shortestAngleInRadians(from first: CGFloat, to second: CGFloat) -> CGFloat {
        let twoPi = CGFloat(.pi * 2.0)
        var angle = (second - first).truncatingRemainder(dividingBy: twoPi)
        if angle >= .pi {
            angle -= twoPi
        }
        if angle <= -.pi {
            angle += twoPi
        }
        return angle
    }
}

public extension CGPoint {
    
    /// EZSE: Constructor from CGVector
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    /// EZSE : Constructor from CGFloat
    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }

    /// EZSE: Adds two CGPoints.
    static func + (this: CGPoint, that: CGPoint) -> CGPoint {
        return CGPoint(x: this.x + that.x, y: this.y + that.y)
    }

    /// EZSE: Subtracts two CGPoints.
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    /// EZSE: Multiplies a CGPoint with a scalar CGFloat.
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// EZSE: Calculates the distance between two CG Points.
    /// Inspired by : http://stackoverflow.com/questions/1906511/how-to-find-the-distance-between-two-cg-points
    static func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
    }

    /// EZSE: Normalizes the vector described by the CGPoint to length 1.0 and returns the result as a new CGPoint.
    func normalized() -> CGPoint {
        let len = CGPoint.distance(from: self, to: CGPoint.zero)
        return CGPoint(x: self.x / len, y: self.y / len)
    }

    //// EZSE: Returns the angle represented by the point.
   var angle: CGFloat {
        return atan2(y, x)
    }

    //// EZSE: Returns the dot product of two vectors represented by points
    static func dotProduct(this: CGPoint, that: CGPoint) -> CGFloat {
        return this.x * that.x + this.y * that.y
    }

    /// EZSE: Performs a linear interpolation between two CGPoint values.
    /// Inspired by https://github.com/raywenderlich/SKTUtils/blob/master/SKTUtils/CGPoint%2BExtensions.swift
    static func linearInterpolation(startPoint: CGPoint, endPoint: CGPoint, interpolationParam: CGFloat) -> CGPoint {
        return startPoint + (endPoint - startPoint) * interpolationParam
    }
}

public extension CGRect {
    /// EZSE: Easier initialization of CGRect
    init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }

    /// EZSE: X value of CGRect's origin
    var x: CGFloat {
        get {
            return self.origin.x
        } set(value) {
            self.origin.x = value
        }
    }
    
    /// EZSE: Y value of CGRect's origin
    var y: CGFloat {
        get {
            return self.origin.y
        } set(value) {
            self.origin.y = value
        }
    }

    /// EZSE: Width of CGRect's size
    var w: CGFloat {
        get {
            return self.size.width
        } set(value) {
            self.size.width = value
        }
    }

    /// EZSE: Height of CGRect's size
    var h: CGFloat {
        get {
            return self.size.height
        } set(value) {
            self.size.height = value
        }
    }
    
    /// EZSE : Surface Area represented by a CGRectangle
    var area: CGFloat {
        return self.h * self.w
    }
}



#endif

public extension Character {
    /// EZSE: Converts Character to String //TODO: Add to readme
    var toString: String { return String(self) }

    /// EZSE: If the character represents an integer that fits into an Int, returns the corresponding integer.
    ///TODO: Add to readme
    var toInt: Int? { return Int(String(self)) }

    /// EZSE: Convert the character to lowercase
    var lowercased: Character {
            let s = String(self).lowercased()
            return s[s.startIndex]
    }

    /// EZSE: Convert the character to uppercase
    var uppercased: Character {
            let s = String(self).uppercased()
            return s[s.startIndex]
    }
    
    /// EZSE : Checks if character is emoji
    var isEmoji: Bool {
        return String(self).includesEmoji()
    }
}

/// EZSE: This Date Formatter Manager help to cache already created formatter in a synchronized Dictionary to use them in future, helps in performace improvement.
class DateFormattersManager {
    public static var dateFormatters: SynchronizedDictionary = SynchronizedDictionary<String, DateFormatter>()
}

extension Date {
    
    public static let minutesInAWeek = 24 * 60 * 7
    
    /// EZSE: Initializes Date from string and format
    public init?(fromString string: String,
                 format: String,
                 timezone: TimeZone = TimeZone.autoupdatingCurrent,
                 locale: Locale = Locale.current) {
        if let dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format) {
            if let date = dateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        } else {
            let formatter = DateFormatter()
            formatter.timeZone = timezone
            formatter.locale = locale
            formatter.dateFormat = format
            DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
            if let date = formatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }
    
    /// EZSE: Initializes Date from string returned from an http response, according to several RFCs / ISO
    public init?(httpDateString: String) {
        if let rfc1123 = Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        if let iso8601DateOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd") {
            self = iso8601DateOnly
            return
        }
        if let iso8601DateHrMinOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mmxxxxx") {
            self = iso8601DateHrMinOnly
            return
        }
        if let iso8601DateHrMinSecOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            self = iso8601DateHrMinSecOnly
            return
        }
        if let iso8601DateHrMinSecMs = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx") {
            self = iso8601DateHrMinSecMs
            return
        }
        return nil
    }
    
    /// EZSE: Converts Date to String
    public func toString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    /// EZSE: Converts Date to String, with format
    public func toString(format: String) -> String {
        
        let dateFormatter = getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
    
    /// EZSE: Use to get dateFormatter from synchronized Dict via dateFormatterManager
    private func getDateFormatter(for format: String) -> DateFormatter {
        
        var dateFormatter: DateFormatter?
        if let _dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format) {
             dateFormatter = _dateFormatter
        } else {
            dateFormatter = createDateFormatter(for: format)
        }
        
        return dateFormatter!
    }
    
    ///EZSE: CreateDateFormatter if formatter doesn't exist in Dict.
    private func createDateFormatter(for format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
        return formatter
    }
    
    /// EZSE: Calculates how many days passed from now to date
    public func daysInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/86400)
        return diff
    }
    
    /// EZSE: Calculates how many hours passed from now to date
    public func hoursInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/3600)
        return diff
    }
    
    /// EZSE: Calculates how many minutes passed from now to date
    public func minutesInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/60)
        return diff
    }
    
    /// EZSE: Calculates how many seconds passed from now to date
    public func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }
    
    /// EZSE: Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        var str: String
        
        if components.year! >= 1 {
            components.year == 1 ? (str = "year") : (str = "years")
            return "\(components.year!) \(str) ago"
        } else if components.month! >= 1 {
            components.month == 1 ? (str = "month") : (str = "months")
            return "\(components.month!) \(str) ago"
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "day") : (str = "days")
            return "\(components.day!) \(str) ago"
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "hour") : (str = "hours")
            return "\(components.hour!) \(str) ago"
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "minute") : (str = "minutes")
            return "\(components.minute!) \(str) ago"
        } else if components.second! >= 1 {
            components.second == 1 ? (str = "second") : (str = "seconds")
            return "\(components.second!) \(str) ago"
        } else {
            return "Just now"
        }
    }
    
    /// EZSE: Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds. Useful for localization
    public func timePassed() -> TimePassed {
        
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        
        if components.year! >= 1 {
            return TimePassed.year(components.year!)
        } else if components.month! >= 1 {
            return TimePassed.month(components.month!)
        } else if components.day! >= 1 {
            return TimePassed.day(components.day!)
        } else if components.hour! >= 1 {
            return TimePassed.hour(components.hour!)
        } else if components.minute! >= 1 {
            return TimePassed.minute(components.minute!)
        } else if components.second! >= 1 {
            return TimePassed.second(components.second!)
        } else {
            return TimePassed.now
        }
    }
    
    /// EZSE: Check if date is in future.
    public var isFuture: Bool {
        return self > Date()
    }
    
    /// EZSE: Check if date is in past.
    public var isPast: Bool {
        return self < Date()
    }
    
    // EZSE: Check date if it is today
    public var isToday: Bool {
        let format = "yyyy-MM-dd"
        let dateFormatter = getDateFormatter(for: format)
        return dateFormatter.string(from: self) == dateFormatter.string(from: Date())
    }
    
    /// EZSE: Check date if it is yesterday
    public var isYesterday: Bool {
        let format = "yyyy-MM-dd"
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = getDateFormatter(for: format)
        return dateFormatter.string(from: self) == dateFormatter.string(from: yesterDay!)
    }
    
    /// EZSE: Check date if it is tomorrow
    public var isTomorrow: Bool {
        let format = "yyyy-MM-dd"
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let dateFormatter = getDateFormatter(for: format)
        
        return dateFormatter.string(from: self) == dateFormatter.string(from: tomorrow!)
    }
    
    /// EZSE: Check date if it is within this month.
    public var isThisMonth: Bool {
        let today = Date()
        return self.month == today.month && self.year == today.year
    }
    
    /// EZSE: Check date if it is within this week.
    public var isThisWeek: Bool {
        return self.minutesInBetweenDate(Date()) <= Double(Date.minutesInAWeek)
    }
    
    /// EZSE: Get the era from the date
    public var era: Int {
        return Calendar.current.component(Calendar.Component.era, from: self)
    }
    
    /// EZSE : Get the year from the date
    public var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    /// EZSE : Get the month from the date
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    /// EZSE : Get the weekday from the date
    public var weekday: String {
        let format = "EEEE"
        let dateFormatter = getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
    
    // EZSE : Get the month from the date
    public var monthAsString: String {
        let format = "MMMM"
        let dateFormatter = getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
    
    // EZSE : Get the day from the date
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// EZSE: Get the hours from date
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// EZSE: Get the minute from date
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// EZSE: Get the second from the date
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// EZSE : Gets the nano second from the date
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    
    #if os(iOS) || os(tvOS)
    
    /// EZSE : Gets the international standard(ISO8601) representation of date
    @available(iOS 10.0, *)
    @available(tvOS 10.0, *)
    public var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    #endif
}


/// EZSE: This Synchronized Dictionary gets generic key, value types and used for the purpose of read, write on a dictionary Synchronized.
public class SynchronizedDictionary <Key: Hashable, Value> {
    
    fileprivate let queue = DispatchQueue(label: "SynchronizedDictionary", attributes: .concurrent)
    fileprivate var dict = [Key: Value]()
    
    func getValue(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            value = dict[key]
        }
        return value
    }
    
    func setValue(for key: Key, value: Value) {
        queue.sync {
            dict[key] = value
        }
    }
    
    func getSize() -> Int {
        return dict.count
    }
    
    func containValue(for key: Key) -> Bool {
        return dict.has(key)
    }
}


#if os(iOS) || os(tvOS)

public extension NSObject {
    var className: String {
        return type(of: self).className
    }

    static var className: String {
        return String(describing: self)
    }
}

#endif

public extension NSDictionary {

    // MARK: - Deprecated 1.8
    /// EZSE: Unserialize JSON string into NSDictionary
    @available(*, deprecated)
    convenience init ? (json: String) {
        if let data = (try? JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
            self.init(dictionary: data)
        } else {
            self.init()
            return nil
        }
    }

    /// EZSE: Serialize NSDictionary into JSON string
    @available(*, deprecated)
    func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
            return String(jsonStr ?? "")
        }
        return nil
    }
}


#if os(iOS) || os(tvOS)

public extension NSAttributedString {
    /// EZSE: Adds bold attribute to NSAttributedString and returns it
    #if os(iOS)

    func bold() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }

    #endif

    /// EZSE: Adds underline attribute to NSAttributedString and returns it
    func underline() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue], range: range)
        return copy
    }

    #if os(iOS)

    /// EZSE: Adds italic attribute to NSAttributedString and returns it
    func italic() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)], range: range)
        return copy
    }

    /// EZSE: Adds strikethrough attribute to NSAttributedString and returns it
    func strikethrough() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        let range = (self.string as NSString).range(of: self.string)
        let attributes = [
            NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)]
        copy.addAttributes(attributes, range: range)

        return copy
    }

    #endif

    /// EZSE: Adds color attribute to NSAttributedString and returns it
    func color(_ color: UIColor) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }

        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedStringKey.foregroundColor: color], range: range)
        return copy
    }
}

/// EZSE: Appends one NSAttributedString to another NSAttributedString and returns it
public func += (left: inout NSAttributedString, right: NSAttributedString) {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.append(right)
    left = ns
}
    
/// EZSE: Sum of one NSAttributedString with another NSAttributedString
public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.append(right)
    return ns
}

#endif


public extension Int {
    /// EZSE: Checks if the integer is even.
    var isEven: Bool { return (self % 2 == 0) }

    /// EZSE: Checks if the integer is odd.
    var isOdd: Bool { return (self % 2 != 0) }

    /// EZSE: Checks if the integer is positive.
    var isPositive: Bool { return (self > 0) }

    /// EZSE: Checks if the integer is negative.
    var isNegative: Bool { return (self < 0) }

    /// EZSE: Converts integer value to Double.
    var toDouble: Double { return Double(self) }

    /// EZSE: Converts integer value to Float.
    var toFloat: Float { return Float(self) }

    /// EZSE: Converts integer value to CGFloat.
    var toCGFloat: CGFloat { return CGFloat(self) }

    /// EZSE: Converts integer value to String.
    var toString: String { return String(self) }

    /// EZSE: Converts integer value to UInt.
    var toUInt: UInt { return UInt(self) }

    /// EZSE: Converts integer value to Int32.
    var toInt32: Int32 { return Int32(self) }

    /// EZSE: Converts integer value to a 0..<Int range. Useful in for loops.
    var range: CountableRange<Int> { return 0..<self }

    /// EZSE: Returns number of digits in the integer.
    var digits: Int {
        if self == 0 {
            return 1
        } else {
            return Int(log10(fabs(Double(self)))) + 1
        }
    }
    
    /// EZSE: The digits of an integer represented in an array(from most significant to least).
    /// This method ignores leading zeros and sign
    var digitArray: [Int] {
        var digits = [Int]()
        for char in self.toString {
            if let digit = Int(String(char)) {
                digits.append(digit)
            }
        }
        return digits
    }

    /// EZSE: Returns a random integer number in the range min...max, inclusive.
    static func random(within: Range<Int>) -> Int {
        let delta = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}

extension UInt {
    /// EZSE: Convert UInt to Int
    public var toInt: Int { return Int(self) }
    
    /// EZSE: Greatest common divisor of two integers using the Euclid's algorithm.
    /// Time complexity of this in O(log(n))
    public static func gcd(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        let remainder = firstNum % secondNum
        if remainder != 0 {
            return gcd(secondNum, remainder)
        } else {
            return secondNum
        }
    }
    
    /// EZSE: Least common multiple of two numbers. LCM = n * m / gcd(n, m)
    public static func lcm(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        return firstNum * secondNum / UInt.gcd(firstNum, secondNum)
    }
}


public extension Hashable {
    
    /// EZSE: A string representation of the hash value.
    var hashString: String {
        return String(self.hashValue)
    }
}


public extension Dictionary {
   
    /// EZSE: Returns the value of a random Key-Value pair from the Dictionary
    func random() -> Value? {
        return Array(values).random()
    }

    /// EZSE: Union of self and the input dictionaries.
    func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (key, value) -> Void in
                result[key] = value
            }
        }
        return result
    }

    /// EZSE: Intersection of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] copules.
    func intersection<K, V: Equatable>(_ dictionaries: [K: V]...) -> [K: V] {
        //  Casts self from [Key: Value] to [K: V]
        let filtered = mapFilter { (item, value) -> (K, V)? in
            if let item = item as? K, let value = value as? V {
                return (item, value)
            }
            return nil
        }

        //  Intersection
        
        return filtered.filter { (arg: (key: K, value: V)) -> Bool in
            //  check for [key: value] in all the dictionaries
            
            let (key, value) = arg
            return dictionaries.testAll { $0.has(key) && $0[key] == value }
        }
    }

    /// EZSE: Checks if a key exists in the dictionary.
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /// EZSE: Creates an Array with values generated by running
    /// each [key: value] of self through the mapFunction.
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }

    /// EZSE: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction.
    func mapValues<V>(_ map: (Key, Value) -> V) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            mapped[$0] = map($0, $1)
        }
        return mapped
    }

    /// EZSE: Creates a Dictionary with the same keys as self and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    func mapFilterValues<V>(_ map: (Key, Value) -> V?) -> [Key: V] {
        var mapped: [Key: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[$0] = value
            }
        }
        return mapped
    }

    /// EZSE: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction discarding nil return values.
    func mapFilter<K, V>(_ map: (Key, Value) -> (K, V)?) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            if let value = map($0, $1) {
                mapped[value.0] = value.1
            }
        }
        return mapped
    }

    /// EZSE: Creates a Dictionary with keys and values generated by running
    /// each [key: value] of self through the mapFunction.
    func map<K, V>(_ map: (Key, Value) -> (K, V)) -> [K: V] {
        var mapped: [K: V] = [:]
        forEach {
            let (_key, _value) = map($0, $1)
            mapped[_key] = _value
        }
        return mapped
    }

    /// EZSE: Constructs a dictionary containing every [key: value] pair from self
    /// for which testFunction evaluates to true.
    func filter(_ test: (Key, Value) -> Bool) -> Dictionary {
        var result = Dictionary()
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        return result
    }

    /// EZSE: Checks if test evaluates true for all the elements in self.
    func testAll(_ test: (Key, Value) -> (Bool)) -> Bool {
        return !contains { !test($0, $1) }
    }

    /// EZSE: Unserialize JSON string into Dictionary
    static func constructFromJSON (json: String) -> Dictionary? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary {
            return data
        } else {
            return nil
        }
    }

    /// EZSE: Serialize Dictionary into JSON string
    func formatJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }

}

extension Dictionary where Value: Equatable {
    /// EZSE: Difference of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] pairs.
    public func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
}

/// EZSE: Combines the first dictionary with the second and returns single dictionary
public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

/// EZSE: Difference operator
public func - <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.difference(second)
}

/// EZSE: Intersection operator
public func & <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.intersection(second)
}

/// EZSE: Union operator
public func | <K, V> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.union(second)
}

#if os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS)
    import UIKit
#endif

public extension String {
    /// EZSE: Init string with a base64 encoded string
    init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }
    
    /// EZSE: base64 encoded of string
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    /// EZSE: Cut string from integerIndex to the end
    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    /// EZSE: Cut string from range
    subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    /// EZSE: Cut string from closedrange
    subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }
    
    /// EZSE: Character count
    var length: Int {
        return self.count
    }
    
    /// EZSE: Counts number of instances of the input inside String
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// EZSE: Capitalizes first character of String
    mutating func capitalizeFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
    
    /// EZSE: Capitalizes first character of String, returns a new string
    func capitalizedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    /// EZSE: Uppercases first 'count' characters of String
    mutating func uppercasePrefix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
    }
    
    /// EZSE: Uppercases first 'count' characters of String, returns a new string
    func uppercasedPrefix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
        return result
    }
    
    /// EZSE: Uppercases last 'count' characters of String
    mutating func uppercaseSuffix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
    }
    
    /// EZSE: Uppercases last 'count' characters of String, returns a new string
    func uppercasedSuffix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
        return result
    }
    
    /// EZSE: Uppercases string in range 'range' (from range.startIndex to range.endIndex)
    mutating func uppercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
    }
    
    /// EZSE: Uppercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    func uppercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
        return result
    }
    
    /// EZSE: Lowercases first character of String
    mutating func lowercaseFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    }
    
    /// EZSE: Lowercases first character of String, returns a new string
    func lowercasedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
    
    /// EZSE: Lowercases first 'count' characters of String
    mutating func lowercasePrefix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
    }
    
    /// EZSE: Lowercases first 'count' characters of String, returns a new string
    func lowercasedPrefix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
        return result
    }
    
    /// EZSE: Lowercases last 'count' characters of String
    mutating func lowercaseSuffix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
    }
    
    /// EZSE: Lowercases last 'count' characters of String, returns a new string
    func lowercasedSuffix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
        return result
    }
    
    /// EZSE: Lowercases string in range 'range' (from range.startIndex to range.endIndex)
    mutating func lowercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
    }
    
    /// EZSE: Lowercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    func lowercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
        return result
    }
    
    /// EZSE: Counts whitespace & new lines
    @available(*, deprecated, renamed: "isBlank")
    func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines
        let newText = self.trimmingCharacters(in: characterSet)
        return newText.isEmpty
    }
    
    /// EZSE: Checks if string is empty or consists only of whitespace and newline characters
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// EZSE: Trims white space and new line characters
    mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// EZSE: Position of begining character of substing
    func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    /// EZSE: split string using a spearator string, returns an array of string
    func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// EZSE: split string with delimiters, returns an array of string
    func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// EZSE : Returns count of words in string
    var countofWords: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
        return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
    }
    
    /// EZSE : Returns count of paragraphs in string
    var countofParagraphs: Int {
        let regex = try? NSRegularExpression(pattern: "\\n", options: NSRegularExpression.Options())
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (regex?.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: str.length)) ?? -1) + 1
    }
    
    internal func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        
        let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location)
        let to16 = utf16.index(from16, offsetBy: nsRange.length)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    /// EZSE: Find matches of regular expression in string
    func matchesForRegexInText(_ regex: String!) -> [String] {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length)) ?? []
        return results.map { String(self[self.rangeFromNSRange($0.range)!]) }
    }
    
    /// EZSE: Checks if String contains Email
    var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /// EZSE: Returns if String is a number
    func isNumber() -> Bool {
        return NumberFormatter().number(from: self) != nil ? true : false
    }
    
    /// EZSE: Extracts URLS from String
    var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }
        
        let text = self
        
        if let detector = detector {
            detector.enumerateMatches(in: text,
                                      options: [],
                                      range: NSRange(location: 0, length: text.count),
                                      using: { (result: NSTextCheckingResult?, _, _) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }
        
        return urls
    }
    
    /// EZSE: Checking if String contains input with comparing options
    func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    /// EZSE: Converts String to Int
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    ///EZSE: Returns the first index of the occurency of the character in String
    func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in self.enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// EZSE: Converts String to NSString
    var toNSString: NSString { return self as NSString }
    
    #if os(iOS)
    
    ///EZSE: Returns bold NSAttributedString
    func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        return boldString
    }
    
    #endif
    
    #if os(iOS)

    ///EZSE: Returns underlined NSAttributedString
    func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return underlineString
    }
    
    #endif
    
    #if os(iOS)
    
    ///EZSE: Returns italic NSAttributedString
    func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    #endif
    
    #if os(iOS)
    
    ///EZSE: Returns hight of rendered string
    func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSAttributedStringKey.paragraphStyle)
        }
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrib, context: nil).height)
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)
    
    ///EZSE: Returns NSAttributedString
    func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.foregroundColor: color])
        return colorString
    }
    
    ///EZSE: Returns NSAttributedString
    func colorSubString(_ subString: String, color: UIColor) -> NSMutableAttributedString {
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString, options: NSString.CompareOptions.literal, range: NSRange(location: start, length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
        return attrText
    }
    
    #endif
    
    /// EZSE: Checks if String contains Emoji
    func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    #if os(iOS)
    
    /// EZSE: copy string to pasteboard
    func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    #endif
    
    // EZSE: URL encode a string (percent encoding special chars)
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    // EZSE: URL encode a string (percent encoding special chars) mutating version
    mutating func urlEncode() {
        self = urlEncoded()
    }
    
    // EZSE: Removes percent encoding from string
    func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    
    // EZSE : Mutating versin of urlDecoded
    mutating func urlDecode() {
        self = urlDecoded()
    }
}

public extension String {
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}

/// EZSE: Pattern matching of strings via defined functions
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

/// EZSE: Can be used in switch-case
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

/// EZSE: Can be used in switch-case
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence

public extension Double {
    
    /// EZSE: Converts Double to String
    var toString: String { return String(self) }

    /// EZSE: Converts Double to Int
    var toInt: Int { return Int(self) }
    
    #if os(iOS) || os(tvOS)
    
    /// EZSE: Converts Double to CGFloat
    var toCGFloat: CGFloat { return CGFloat(self) }
    
    #endif
    
    /// EZSE: Creating the exponent operator
    static func ** (lhs: Double, rhs: Double) -> Double {
        return pow(lhs, rhs)
    }
}

// MARK: - Deprecated 1.8
public extension Double {

    /// EZSE: Returns a Double rounded to decimal
    @available(*, deprecated, renamed: "rounded(toPlaces:)")
    func getRoundedByPlaces(_ places: Int) -> Double {
        return rounded(toPlaces: places)
    }

    /// EZSE: Rounds the current Double rounded to decimal
    @available(*, deprecated, renamed: "round(toPlaces:)")
    mutating func roundByPlaces(_ places: Int) {
        self.round(toPlaces: places)
    }

    /// EZSE: Returns a Double Ceil to decimal
    @available(*, deprecated, renamed: "ceiled(toPlaces:)")
    func getCeiledByPlaces(_ places: Int) -> Double {
        return ceiled(toPlaces: places)
    }

    /// EZSE: Ceils current Double to number of places
    @available(*, deprecated, renamed: "ceil(toPlaces:)")
    mutating func ceilByPlaces(_ places: Int) {
        self.ceil(toPlaces: places)
    }
    
    /// EZSE: Absolute value of Double.
    var abs: Double {
        if self > 0 {
            return self
        } else {
            return -self
        }
    }

}

public extension FloatingPoint {

    /// EZSE: Returns rounded FloatingPoint to specified number of places
    func rounded(toPlaces places: Int) -> Self {
        guard places >= 0 else { return self }
        var divisor: Self = 1
        for _ in 0..<places { divisor *= 10 }
        return (self * divisor).rounded() / divisor
    }

    /// EZSE: Rounds current FloatingPoint to specified number of places
    mutating func round(toPlaces places: Int) {
        self = rounded(toPlaces: places)
    }

    /// EZSE: Returns ceiled FloatingPoint to specified number of places
    func ceiled(toPlaces places: Int) -> Self {
        guard places >= 0 else { return self }
        var divisor: Self = 1
        for _ in 0..<places { divisor *= 10 }
        return (self * divisor).rounded(.up) / divisor
    }

    /// EZSE: Ceils current FloatingPoint to specified number of places
    mutating func ceil(toPlaces places: Int) {
        self = ceiled(toPlaces: places)
    }
    
    /// EZSE: Returns a random floating point number between 0.0 and 1.0, inclusive.
    static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// EZSE: Returns a random floating point number in the range min...max, inclusive.
    static func random(within: Range<Float>) -> Float {
        return Float.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
}


public struct ez {
    /// EZSE: Returns app's name
    public static var appDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }

        return nil
    }

    /// EZSE: Returns app's version number
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// EZSE: Return app's build number
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// EZSE: Return app's bundle ID
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }

    /// EZSE: Returns both app's version and build numbers "v0.3(7)"
    public static var appVersionAndBuild: String? {
        if appVersion != nil && appBuild != nil {
            if appVersion == appBuild {
                return "v\(appVersion!)"
            } else {
                return "v\(appVersion!)(\(appBuild!))"
            }
        }
        return nil
    }

    /// EZSE: Return device version ""
    public static var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }

    /// EZSE: Returns true if DEBUG mode is active //TODO: Add to readme
    public static var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
    }

    /// EZSE: Returns true if RELEASE mode is active //TODO: Add to readme
    public static var isRelease: Bool {
    #if DEBUG
        return false
    #else
        return true
    #endif
    }

    /// EZSE: Returns true if its simulator and not a device //TODO: Add to readme
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
    #else
        return false
    #endif
    }

    /// EZSE: Returns true if its on a device and not a simulator //TODO: Add to readme
    public static var isDevice: Bool {
        #if targetEnvironment(simulator)
        return false
    #else
        return true
    #endif
    }
    
    #if !os(macOS)
    /// EZSE: Returns true if app is running in test flight mode
    /// Acquired from : http://stackoverflow.com/questions/12431994/detect-testflight
    public static var isInTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    #endif

    #if os(iOS) || os(tvOS)

    /// EZSE: Returns the top ViewController
    public static var topMostVC: UIViewController? {
        let topVC = UIApplication.topViewController()
        if topVC == nil {
            print("EZSwiftExtensions Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return topVC
    }

    #if os(iOS)

    /// EZSE: Returns current screen orientation
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    #endif

    /// EZSwiftExtensions
    public static var horizontalSizeClass: UIUserInterfaceSizeClass {
        return self.topMostVC?.traitCollection.horizontalSizeClass ?? UIUserInterfaceSizeClass.unspecified
    }

    /// EZSwiftExtensions
    public static var verticalSizeClass: UIUserInterfaceSizeClass {
        return self.topMostVC?.traitCollection.verticalSizeClass ?? UIUserInterfaceSizeClass.unspecified
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)

    /// EZSE: Returns screen width
    public static var screenWidth: CGFloat {

        #if os(iOS)

        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.size.width
        } else {
            return UIScreen.main.bounds.size.height
        }

        #elseif os(tvOS)

        return UIScreen.main.bounds.size.width

        #endif
    }

    /// EZSE: Returns screen height
    public static var screenHeight: CGFloat {

        #if os(iOS)

        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width
        }

        #elseif os(tvOS)

            return UIScreen.main.bounds.size.height

        #endif
    }
    
    #endif

    #if os(iOS)

    /// EZSE: Returns StatusBar height
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// EZSE: Return screen's height without StatusBar
    public static var screenHeightWithoutStatusBar: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }

    #endif

    /// EZSE: Returns the locale country code. An example value might be "ES". //TODO: Add to readme
    public static var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }
    
    #if os(iOS) || os(tvOS)

    /// EZSE: Calls action when a screen shot is taken
    public static func detectScreenShot(_ action: @escaping () -> Void) {
        let mainQueue = OperationQueue.main
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue) { _ in
            // executes after screenshot
            action()
        }
    }
    
    #endif

    //TODO: Document this, add tests to this
    /// EZSE: Iterates through enum elements, use with (for element in ez.iterateEnum(myEnum))
    /// http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
    public static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) { $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee } }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }

    // MARK: - Dispatch
    /// EZSE: Runs the function after x seconds
    public static func dispatchDelay(_ second: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    /// EZSE: Runs function after x seconds
    public static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }

    //TODO: Make this easier
    /// EZSE: Runs function after x seconds with dispatch_queue, use this syntax: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }

    /// EZSE: Submits a block for asynchronous execution on the main queue
    public static func runThisInMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    /// EZSE: Runs in Default priority queue
    public static func runThisInBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }

    /// EZSE: Runs every second, to cancel use: timer.invalidate()
    @discardableResult public static func runThisEvery(
        seconds: TimeInterval,
        startAfterSeconds: TimeInterval,
        handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

    /// EZSE: Gobal main queue
    @available(*, deprecated, renamed: "DispatchQueue.main")
    public var globalMainQueue: DispatchQueue {
        return DispatchQueue.main
    }

    /// EZSE: Gobal queue with user interactive priority
    @available(*, deprecated, renamed: "DispatchQueue.main")

    public var globalUserInteractiveQueue: DispatchQueue {
        return DispatchQueue.global(qos: .userInteractive)
    }

    /// EZSE: Gobal queue with user initiated priority
    @available(*, deprecated, renamed: "DispatchQueue.global()")
    public var globalUserInitiatedQueue: DispatchQueue {
        return DispatchQueue.global(qos: .userInitiated)
    }

    /// EZSE: Gobal queue with utility priority
    @available(*, deprecated, renamed: "DispatchQueue.global()")
    public var globalUtilityQueue: DispatchQueue {
        return DispatchQueue.global(qos: .utility)
    }

    /// EZSE: Gobal queue with background priority
    @available(*, deprecated, renamed: "DispatchQueue.global()")
    public var globalBackgroundQueue: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }

    /// EZSE: Gobal queue with default priority
    @available(*, deprecated, renamed: "DispatchQueue.global()")
    public var globalQueue: DispatchQueue {
        return DispatchQueue.global(qos: .default)
    }

    // MARK: - DownloadTask
    
    #if os(iOS) || os(tvOS)

    /// EZSE: Downloads image from url string
    public static func requestImage(_ url: String, success: @escaping (UIImage?) -> Void) {
        requestURL(url, success: { (data) -> Void in
            if let d = data {
                success(UIImage(data: d))
            }
        })
    }
    
    #endif

    /// EZSE: Downloads JSON from url string
    public static func requestJSON(_ url: String, success: @escaping ((Any?) -> Void), error: ((NSError) -> Void)?) {
        requestURL(url,
            success: { (data) -> Void in
                let json = self.dataToJsonDict(data)
                success(json)
            },
            error: { (err) -> Void in
                if let e = error {
                    e(err)
                }
        })
    }

    /// EZSE: converts NSData to JSON dictionary
    fileprivate static func dataToJsonDict(_ data: Data?) -> Any? {
        if let d = data {
            var error: NSError?
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(
                    with: d,
                    options: JSONSerialization.ReadingOptions.allowFragments)
            } catch let error1 as NSError {
                error = error1
                json = nil
            }

            if error != nil {
                return nil
            } else {
                return json
            }
        } else {
            return nil
        }
    }

    /// EZSE:
    fileprivate static func requestURL(_ url: String, success: @escaping (Data?) -> Void, error: ((NSError) -> Void)? = nil) {
        guard let requestURL = URL(string: url) else {
            assertionFailure("EZSwiftExtensions Error: Invalid URL")
            return
        }

        URLSession.shared.dataTask(
            with: URLRequest(url: requestURL),
            completionHandler: { data, _, err in
                if let e = err {
                    error?(e as NSError)
                } else {
                    success(data)
                }
        }).resume()
    }
}


public enum TimePassed {
    
    case year(Int)
    case month(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case second(Int)
    case now
}

extension TimePassed: Equatable {

    public static func ==(lhs: TimePassed, rhs: TimePassed) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.year(let a), .year(let b)):
            return a == b
            
        case (.month(let a), .month(let b)):
            return a == b
            
        case (.day(let a), .day(let b)):
            return a == b
            
        case (.hour(let a), .hour(let b)):
            return a == b
            
        case (.minute(let a), .minute(let b)):
            return a == b
            
        case (.second(let a), .second(let b)):
            return a == b
            
        case (.now, .now):
            return true
            
        default:
            return false
        }
    }
}


public extension Timer {
    /// EZSE: Runs every x seconds, to cancel use: timer.invalidate()
    static func runThisEvery(seconds: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate = CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

    /// EZSE: Run function after x seconds
    static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }

    //TODO: Make this easier
    /// EZSwiftExtensions - dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
}

#if os(iOS) || os(tvOS)

import UIKit

public extension UIAlertController {
    /// EZSE: Easy way to present UIAlertController
    func show() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}

#endif

#if os(iOS) || os(tvOS)
public extension UIApplication {
    /// EZSE: Run a block in background after app resigns activity
    func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }

    /// EZSE: Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

#endif

#if os(iOS) || os(tvOS)

/// EZSwiftExtensions
public enum FontType: String {
    case None = ""
    case Regular = "Regular"
    case Bold = "Bold"
    case DemiBold = "DemiBold"
    case Light = "Light"
    case UltraLight = "UltraLight"
    case Italic = "Italic"
    case Thin = "Thin"
    case Book = "Book"
    case Roman = "Roman"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case CondensedMedium = "CondensedMedium"
    case CondensedExtraBold = "CondensedExtraBold"
    case SemiBold = "SemiBold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
}

/// EZSwiftExtensions
public enum FontName: String {
    case HelveticaNeue
    case Helvetica
    case Futura
    case Menlo
    case Avenir
    case AvenirNext
    case Didot
    case AmericanTypewriter
    case Baskerville
    case Geneva
    case GillSans
    case SanFranciscoDisplay
    case Seravek
}

public extension UIFont {

    /// EZSwiftExtensions
    class func Font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont! {
      //Using type
      let fontName = name.rawValue + "-" + type.rawValue
      if let font = UIFont(name: fontName, size: size) {
          return font
      }

      //That font doens't have that type, try .None
      let fontNameNone = name.rawValue
      if let font = UIFont(name: fontNameNone, size: size) {
          return font
      }

      //That font doens't have that type, try .Regular
      let fontNameRegular = name.rawValue + "-" + "Regular"
      if let font = UIFont(name: fontNameRegular, size: size) {
          return font
      }

      return nil
    }

    /// EZSwiftExtensions
    class func HelveticaNeue(type: FontType, size: CGFloat) -> UIFont {
        return Font(.HelveticaNeue, type: type, size: size)
    }

    /// EZSwiftExtensions
    class func AvenirNext(type: FontType, size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: type, size: size)
    }

    /// EZSwiftExtensions
    class func AvenirNextDemiBold(size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: .DemiBold, size: size)
    }

    /// EZSwiftExtensions
    class func AvenirNextRegular(size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: .Regular, size: size)
    }
}
#endif


#if os(iOS) || os(tvOS)
public extension UILabel {
    
    /// EZSE: Initialize Label with a font, color and alignment.
    convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }

    /// EZSwiftExtensions
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat = 17) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont.HelveticaNeue(type: FontType.None, size: fontSize)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        textAlignment = NSTextAlignment.left
        isUserInteractionEnabled = true
        numberOfLines = 1
    }

    /// EZSwiftExtensions
    func getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }

    /// EZSwiftExtensions
    func getEstimatedHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude)).height
    }

    /// EZSwiftExtensions
    func getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: h)).width
    }

    /// EZSwiftExtensions
    func fitHeight() {
        self.h = getEstimatedHeight()
    }

    /// EZSwiftExtensions
    func fitWidth() {
        self.w = getEstimatedWidth()
    }

    /// EZSwiftExtensions
    func fitSize() {
        self.fitWidth()
        self.fitHeight()
        sizeToFit()
    }
    
    /// EZSwiftExtensions (if duration set to 0 animate wont be)
    func set(text _text: String?, duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = _text
        }, completion: nil)
    }
}
#endif

#if os(iOS)
public extension UISlider {
    ///EZSE: Slider moving to value with animation duration
    func setValue(_ value: Float, duration: Double) {
      UIView.animate(withDuration: duration, animations: { () -> Void in
        self.setValue(self.value, animated: true)
        }, completion: { (_) -> Void in
          UIView.animate(withDuration: duration, animations: { () -> Void in
            self.setValue(value, animated: true)
            }, completion: nil)
      })
    }
}

#endif

#if os(iOS) || os(tvOS)
public extension UIStoryboard {

    /// EZSE: Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// EZSE: Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
}



public extension UITextField {
    /// EZSE: Regular exp for email
    static let emailRegex = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    /// EZSwiftExtensions: Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, font = ThemeFontName
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat = 17) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont.HelveticaNeue(type: FontType.None, size: fontSize)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        textAlignment = NSTextAlignment.left
        isUserInteractionEnabled = true
    }

    /// EZSE: Add left padding to the text in textfield
    func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.always
    }

    /// EZSE: Add a image icon on the left side of the textfield
    func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, w: imageSize.width, h: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.always
    }

    /// EZSE: Ways to validate by comparison
    enum textFieldValidationOptions: Int {
        case equalTo
        case greaterThan
        case greaterThanOrEqualTo
        case lessThan
        case lessThanOrEqualTo
    }
    
    /// EZSE: Validation length of character counts in UITextField
    func validateLength(ofCount count: Int, option: UITextField.textFieldValidationOptions) -> Bool {
        switch option {
        case .equalTo:
            return self.text!.count == count
        case .greaterThan:
            return self.text!.count > count
        case .greaterThanOrEqualTo:
            return self.text!.count >= count
        case .lessThan:
            return self.text!.count < count
        case .lessThanOrEqualTo:
            return self.text!.count <= count
        }
    }

    /// EZSE: Validation of email format based on https://stackoverflow.com/questions/201323/using-a-regular-expression-to-validate-an-email-address and https://stackoverflow.com/questions/2049502/what-characters-are-allowed-in-an-email-address
    // TODO match String.isEmail method
    func validateEmail() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", UITextField.emailRegex)
        return emailTest.evaluate(with: self.text)
    }
    
    /// EZSE: Validation of digits only
    func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsTest = NSPredicate(format: "SELF MATCHES %@", digitsRegEx)
        return digitsTest.evaluate(with: self.text)
    }
}


public extension UITextView {

    /// EZSwiftExtensions: Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, font = ThemeFontName
    convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont.HelveticaNeue(type: FontType.None, size: fontSize)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        textAlignment = NSTextAlignment.left
        isUserInteractionEnabled = true

        #if os(iOS)

        isEditable = false

        #endif

        isScrollEnabled = false
    }

    #if os(iOS)

    /// EZSE: Automatically adds a toolbar with a done button to the top of the keyboard. Tapping the button will dismiss the keyboard.
    func addDoneButton(_ barStyle: UIBarStyle = .default, title: String? = nil) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title ?? "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        ]

        keyboardToolbar.barStyle = barStyle
        keyboardToolbar.sizeToFit()

        inputAccessoryView = keyboardToolbar
    }

    #endif
}


public extension UIUserInterfaceSizeClass {
  /// EZSwiftExtensions
  var stringValue: String {
    switch self.rawValue {
    case 1:
      return "Compact"
    case 2:
      return "Regular"
    default:
      return "Unspecified"
    }
  }
}


public extension UIViewController {
    // MARK: - Notifications
    
    ///EZSE: Adds an NotificationCenter with name and Selector
    func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes an NSNotificationCenter for name
    func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes NotificationCenter'd observer
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    #if os(iOS)
    
    ///EZSE: Adds a NotificationCenter Observer for keyboardWillShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillShowNotification(_ notification: Notification)```
    func addKeyboardWillShowNotification() {
        self.addNotificationObserver(NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidShowNotification(_ notification: Notification)```
    func addKeyboardDidShowNotification() {
        self.addNotificationObserver(NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardWillHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillHideNotification(_ notification: Notification)```
    func addKeyboardWillHideNotification() {
        self.addNotificationObserver(NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidHideNotification(_ notification: Notification)```
    func addKeyboardDidHideNotification() {
        self.addNotificationObserver(NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
    }
    
    ///EZSE: Removes keyboardWillShowNotification()'s NotificationCenter Observer
    func removeKeyboardWillShowNotification() {
        self.removeNotificationObserver(NSNotification.Name.UIKeyboardWillShow.rawValue)
    }
    
    ///EZSE: Removes keyboardDidShowNotification()'s NotificationCenter Observer
    func removeKeyboardDidShowNotification() {
        self.removeNotificationObserver(NSNotification.Name.UIKeyboardDidShow.rawValue)
    }
    
    ///EZSE: Removes keyboardWillHideNotification()'s NotificationCenter Observer
    func removeKeyboardWillHideNotification() {
        self.removeNotificationObserver(NSNotification.Name.UIKeyboardWillHide.rawValue)
    }
    
    ///EZSE: Removes keyboardDidHideNotification()'s NotificationCenter Observer
    func removeKeyboardDidHideNotification() {
        self.removeNotificationObserver(NSNotification.Name.UIKeyboardDidHide.rawValue)
    }
    
    @objc func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidShowWithFrame(frame)
        }
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillShowWithFrame(frame)
        }
    }
    
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillHideWithFrame(frame)
        }
    }
    
    @objc func keyboardDidHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidHideWithFrame(frame)
        }
    }
    
    func keyboardWillShowWithFrame(_ frame: CGRect) {
        
    }
    
    func keyboardDidShowWithFrame(_ frame: CGRect) {
        
    }
    
    func keyboardWillHideWithFrame(_ frame: CGRect) {
        
    }
    
    func keyboardDidHideWithFrame(_ frame: CGRect) {
        
    }
    
    //EZSE: Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    //EZSE: Dismisses keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - VC Container
    
    ///EZSE: Returns maximum y of the ViewController
    var top: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.top
        }
        if let nav = self.navigationController {
            if nav.isNavigationBarHidden {
                return view.top
            } else {
                return nav.navigationBar.bottom
            }
        } else {
            return view.top
        }
    }
    
    ///EZSE: Returns minimum y of the ViewController
    var bottom: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.bottom
        }
        if let tab = tabBarController {
            if tab.tabBar.isHidden {
                return view.bottom
            } else {
                return tab.tabBar.top
            }
        } else {
            return view.bottom
        }
    }
    
    ///EZSE: Returns Tab Bar's height
    var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's height
    var navigationBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.navigationBarHeight
        }
        if let nav = self.navigationController {
            return nav.navigationBar.h
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's color
    var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
    
    ///EZSE: Returns current Navigation Bar
    var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    /// EZSwiftExtensions
    var applicationFrame: CGRect {
        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
    }
    
    // MARK: - VC Flow
    
    ///EZSE: Pushes a view controller onto the receiver’s stack and updates the display.
    func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///EZSE: Pops the top view controller from the navigation stack and updates the display.
    func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }

    /// EZSE: Hide or show navigation bar
    var isNavBarHidden: Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    
    /// EZSE: Added extension for popToRootViewController
    func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    ///EZSE: Presents a view controller modally.
    func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    ///EZSE: Dismisses the view controller that was presented modally by the view controller.
    func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    ///EZSE: Adds the specified view controller as a child of the current view controller.
    func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChildViewController(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    ///EZSE: Adds image named: as a UIImageView in the Background
    func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    ///EZSE: Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
}



// MARK: Custom UIView Initilizers
public extension UIView {
    /// EZSE: convenience contructor to define a view based on width, height and base coordinates.
    @objc convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }

    /// EZSE: puts padding around the view
    convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.w - padding*2, height: superView.h - padding*2))
    }

    /// EZSwiftExtensions - Copies size of superview
    convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.size))
    }
}

// MARK: Frame Extensions
extension UIView {

    /// EZSE: add multiple subviews
    public func addSubviews(_ views: [UIView]) {
        views.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }

    //TODO: Add pics to readme
    /// EZSE: resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.x + aView.w
            let newHeight = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSE: resizes this view so it fits the largest subview
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth = aView.x + aView.w
                let newHeight = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    /// EZSE: resizes this view so as to fit its width.
    public func resizeToFitWidth() {
        let currentHeight = self.h
        self.sizeToFit()
        self.h = currentHeight
    }

    /// EZSE: resizes this view so as to fit its height.
    public func resizeToFitHeight() {
        let currentWidth = self.w
        self.sizeToFit()
        self.w = currentWidth
    }

    /// EZSE: getter and setter for the x coordinate of the frame's origin for the view.
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }

    /// EZSE: getter and setter for the y coordinate of the frame's origin for the view.
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }

    /// EZSE: variable to get the width of the view.
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }

    /// EZSE: variable to get the height of the view.
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }

    /// EZSE: getter and setter for the x coordinate of leftmost edge of the view.
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    /// EZSE: getter and setter for the x coordinate of the rightmost edge of the view.
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }

    /// EZSE: getter and setter for the y coordinate for the topmost edge of the view.
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    /// EZSE: getter and setter for the y coordinate of the bottom most edge of the view.
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }

    /// EZSE: getter and setter the frame's origin point of the view.
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    /// EZSE: getter and setter for the X coordinate of the center of a view.
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    /// EZSE: getter and setter for the Y coordinate for the center of a view.
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    /// EZSE: getter and setter for frame size for the view.
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    /// EZSE: getter for an leftwards offset position from the leftmost edge.
    public func leftOffset(_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }

    /// EZSE: getter for an rightwards offset position from the rightmost edge.
    public func rightOffset(_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }

    /// EZSE: aligns the view to the top by a given offset.
    public func topOffset(_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }

    /// EZSE: align the view to the bottom by a given offset.
    public func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }

    //TODO: Add to readme
    /// EZSE: align the view widthwise to the right by a given offset.
    public func alignRight(_ offset: CGFloat) -> CGFloat {
        return self.w - offset
    }

    /// EZSwiftExtensions
    public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }

    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    /// EZSE: Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.x = parentView.w/2 - self.w/2
    }

    /// EZSE: Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.y = parentView.h/2 - self.h/2
    }

    /// EZSE: Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}

// MARK: Transform Extensions
extension UIView {
    /// EZSwiftExtensions
    public func setRotationX(_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }

    /// EZSwiftExtensions
    public func setRotationY(_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }

    /// EZSwiftExtensions
    public func setRotationZ(_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    /// EZSwiftExtensions
    public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }

    /// EZSwiftExtensions
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}

// MARK: Layer Extensions
extension UIView {
    /// EZSwiftExtensions
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    //TODO: add this to readme
    /// EZSwiftExtensions
    public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }

    /// EZSwiftExtensions
    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }

    /// EZSwiftExtensions
    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }

    //TODO: add to readme
    /// EZSwiftExtensions
    public func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding*2, height: size, color: color)
    }

    /// EZSwiftExtensions
    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }

    /// EZSwiftExtensions
    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }

    /// EZSwiftExtensions
    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }

    /// EZSwiftExtensions
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    //TODO: add this to readme
    /// EZSwiftExtensions
    public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
    //TODO: add this to readme
    /// EZSwiftExtensions
    public func drawStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

//TODO: add this to readme
// MARK: Animation Extensions
extension UIView {
    /// EZSwiftExtensions
    public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    /// EZSwiftExtensions
    public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIViewAnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }

    /// EZSwiftExtensions
    public func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    /// EZSwiftExtensions
    public func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    /// EZSwiftExtensions
    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }

    /// EZSwiftExtensions
    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }

    //EZSE: Reverse pop, good for button animations
    public func reversePop() {
        setScale(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.05, delay: 0, options: .allowUserInteraction, animations: {[weak self] in
            self?.setScale(x: 1, y: 1)
        }, completion: { (_) in })
    }
}

//TODO: add this to readme
// MARK: Render Extensions
extension UIView {
    /// EZSwiftExtensions
    public func toImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

// MARK: Gesture Extensions
extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    /// EZSwiftExtensions
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions
    public func addSwipeGesture(direction: UISwipeGestureRecognizerDirection, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction

        #if os(iOS)

        swipe.numberOfTouchesRequired = numberOfTouches

        #endif

        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addSwipeGesture(direction: UISwipeGestureRecognizerDirection, numberOfTouches: Int = 1, action: ((UISwipeGestureRecognizer) -> Void)?) {
        let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions
    public func addPanGesture(target: AnyObject, action: Selector) {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addPanGesture(action: ((UIPanGestureRecognizer) -> Void)?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }

    #if os(iOS)

    /// EZSwiftExtensions
    public func addPinchGesture(target: AnyObject, action: Selector) {
        let pinch = UIPinchGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }

    #endif

    #if os(iOS)

    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addPinchGesture(action: ((UIPinchGestureRecognizer) -> Void)?) {
        let pinch = BlockPinch(action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }

    #endif

    /// EZSwiftExtensions
    public func addLongPressGesture(target: AnyObject, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }

    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addLongPressGesture(action: ((UILongPressGestureRecognizer) -> Void)?) {
        let longPress = BlockLongPress(action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
}

//TODO: add to readme
extension UIView {
    /// EZSwiftExtensions [UIRectCorner.TopLeft, UIRectCorner.TopRight]
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    /// EZSwiftExtensions - Mask square/rectangle UIView with a circular/capsule cover, with a border of desired color and width around it
    public func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
        self.setCornerRadius(radius: min(self.frame.size.height, self.frame.size.width) / 2)
        self.layer.borderWidth = width ?? 0
        self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
    }
    
    /// EZSwiftExtensions - Remove all masking around UIView
    public func nakedView() {
        self.layer.mask = nil
        self.layer.borderWidth = 0
    }
}

extension UIView {
    ///EZSE: Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100

        self.layer.add(anim, forKey: nil)
    }
}

extension UIView {
    ///EZSE: Loops until it finds the top root view. //TODO: Add to readme
    func rootView() -> UIView {
        guard let parentView = superview else {
            return self
        }
        return parentView.rootView()
    }
}

// MARK: Fade Extensions
public let UIViewDefaultFadeDuration: TimeInterval = 0.4

extension UIView {
    ///EZSE: Fade in with duration, delay and completion block.
    public func fadeIn(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(1.0, duration: duration, delay: delay, completion: completion)
    }

    /// EZSwiftExtensions
    public func fadeOut(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(0.0, duration: duration, delay: delay, completion: completion)
    }

    /// Fade to specific value     with duration, delay and completion block.
    public func fadeTo(_ value: CGFloat, duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? UIViewDefaultFadeDuration, delay: delay ?? UIViewDefaultFadeDuration, options: .curveEaseInOut, animations: {
            self.alpha = value
        }, completion: completion)
    }
}

#endif

#if os(iOS)

import UIKit

public extension UISwitch {

    /// EZSE: toggles Switch
    func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}

#endif


#if os(iOS) || os(tvOS)

public typealias BlockButtonAction = (_ sender: BlockButton) -> Void

///Make sure you use  "[weak self] (sender) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockButton: UIButton {
    // MARK: Propeties
    open var highlightLayer: CALayer?
    open var action: BlockButtonAction?

    // MARK: Init
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        defaultInit()
    }

    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        super.init(frame: CGRect(x: x, y: y, width: w, height: h))
        defaultInit()
    }

    public init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, action: BlockButtonAction?) {
        super.init (frame: CGRect(x: x, y: y, width: w, height: h))
        self.action = action
        defaultInit()
    }

    public init(action: @escaping BlockButtonAction) {
        super.init(frame: CGRect.zero)
        self.action = action
        defaultInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }

    public init(frame: CGRect, action: @escaping BlockButtonAction) {
        super.init(frame: frame)
        self.action = action
        defaultInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }

    private func defaultInit() {
        addTarget(self, action: #selector(BlockButton.didPressed(_:)), for: UIControlEvents.touchUpInside)
        addTarget(self, action: #selector(BlockButton.highlight), for: [UIControlEvents.touchDown, UIControlEvents.touchDragEnter])
        addTarget(self, action: #selector(BlockButton.unhighlight), for: [
            UIControlEvents.touchUpInside,
            UIControlEvents.touchUpOutside,
            UIControlEvents.touchCancel,
            UIControlEvents.touchDragExit
        ])
        setTitleColor(UIColor.black, for: UIControlState.normal)
        setTitleColor(UIColor.blue, for: UIControlState.selected)
    }

    open func addAction(_ action: @escaping BlockButtonAction) {
        self.action = action
    }

    // MARK: Action
    @objc open func didPressed(_ sender: BlockButton) {
        action?(sender)
    }

    // MARK: Highlight
    @objc open func highlight() {
        if action == nil {
            return
        }
        let highlightLayer = CALayer()
        highlightLayer.frame = layer.bounds
        highlightLayer.backgroundColor = UIColor.black.cgColor
        highlightLayer.opacity = 0.5
        var maskImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            maskImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        let maskLayer = CALayer()
        maskLayer.contents = maskImage?.cgImage
        maskLayer.frame = highlightLayer.frame
        highlightLayer.mask = maskLayer
        layer.addSublayer(highlightLayer)
        self.highlightLayer = highlightLayer
    }

    @objc open func unhighlight() {
        if action == nil {
            return
        }
        highlightLayer?.removeFromSuperlayer()
        highlightLayer = nil
    }
}

#endif


#if os(iOS) || os(tvOS)

///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockLongPress: UILongPressGestureRecognizer {
    private var longPressAction: ((UILongPressGestureRecognizer) -> Void)?

    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
        self.init()
        longPressAction = action
        addTarget(self, action: #selector(BlockLongPress.didLongPressed(_:)))
    }

    @objc open func didLongPressed(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == UIGestureRecognizerState.began {
            longPressAction?(longPress)
        }
    }
}

#endif


#if os(iOS) || os(tvOS)
///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockPan: UIPanGestureRecognizer {
    private var panAction: ((UIPanGestureRecognizer) -> Void)?

    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
    }

    @objc open func didPan (_ pan: UIPanGestureRecognizer) {
        panAction? (pan)
    }
}

#endif


#if os(iOS)


///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockPinch: UIPinchGestureRecognizer {
    private var pinchAction: ((UIPinchGestureRecognizer) -> Void)?

    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init (action: ((UIPinchGestureRecognizer) -> Void)?) {
        self.init()
        self.pinchAction = action
        self.addTarget(self, action: #selector(BlockPinch.didPinch(_:)))
    }

    @objc open func didPinch (_ pinch: UIPinchGestureRecognizer) {
        pinchAction? (pinch)
    }
}

#endif

#if os(iOS) || os(tvOS)
///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockSwipe: UISwipeGestureRecognizer {
    private var swipeAction: ((UISwipeGestureRecognizer) -> Void)?

    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init (
        direction: UISwipeGestureRecognizerDirection,
        fingerCount: Int = 1,
        action: ((UISwipeGestureRecognizer) -> Void)?) {
            self.init()
            self.direction = direction

            #if os(iOS)

            numberOfTouchesRequired = fingerCount

            #endif

            swipeAction = action
            addTarget(self, action: #selector(BlockSwipe.didSwipe(_:)))
    }

    @objc open func didSwipe (_ swipe: UISwipeGestureRecognizer) {
        swipeAction? (swipe)
    }
}

#endif


#if os(iOS) || os(tvOS)

///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
public class BlockTap: UITapGestureRecognizer {
    private var tapAction: ((UITapGestureRecognizer) -> Void)?

    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    public convenience init (
        tapCount: Int = 1,
        fingerCount: Int = 1,
        action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount

            #if os(iOS)

            self.numberOfTouchesRequired = fingerCount

            #endif

            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }

    @objc open func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }
}

#endif


#if os(iOS) || os(tvOS)

public extension URL {
    /// EZSE: Returns convert query to Dictionary
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }

        return parameters
    }

    /// EZSE: Returns remote size of url, don't use it in main thread
    func remoteSize(_ completionHandler: @escaping ((_ contentLength: Int64) -> Void), timeoutInterval: TimeInterval = 30) {
        let request = NSMutableURLRequest(url: self, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        request.setValue("", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request as URLRequest) { (_, response, _) in
            let contentLength: Int64 = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            DispatchQueue.global(qos: .default).async(execute: {
                completionHandler(contentLength)
            })
        }.resume()
    }

    /// EZSE: Returns server supports resuming or not, don't use it in main thread
    func supportsResume(_ completionHandler: @escaping ((_ doesSupport: Bool) -> Void), timeoutInterval: TimeInterval = 30) {
        let request = NSMutableURLRequest(url: self, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        request.setValue("bytes=5-10", forHTTPHeaderField: "Range")
        URLSession.shared.dataTask(with: request as URLRequest) { (_, response, _) -> Void in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            DispatchQueue.global(qos: .default).async(execute: {
                completionHandler(responseCode == 206)
            })
        }.resume()
    }

    /// EZSE: Compare two URLs
    func isSameWithURL(_ url: URL) -> Bool {
        if self == url {
            return true
        }
        if self.scheme?.lowercased() != url.scheme?.lowercased() {
            return false
        }
        if let host1 = self.host, let host2 = url.host {
            let whost1 = host1.hasPrefix("www.") ? host1 : "www." + host1
            let whost2 = host2.hasPrefix("www.") ? host2 : "www." + host2
            if whost1 != whost2 {
                return false
            }
        }
        let pathdelimiter = CharacterSet(charactersIn: "/")
        if self.path.lowercased().trimmingCharacters(in: pathdelimiter) != url.path.lowercased().trimmingCharacters(in: pathdelimiter) {
            return false
        }
        if (self as NSURL).port != (url as NSURL).port {
            return false
        }
        if self.query?.lowercased() != url.query?.lowercased() {
            return false
        }
        return true
    }

    /// EZSE: Returns true if given file is a directory
    var fileIsDirectory: Bool {
        var isdirv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&isdirv, forKey: URLResourceKey.isDirectoryKey)
        } catch _ {
        }
        return isdirv?.boolValue ?? false
    }

    /// EZSE: File modification date, nil if file doesn't exist
    var fileModifiedDate: Date? {
        get {
            var datemodv: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&datemodv, forKey: URLResourceKey.contentModificationDateKey)
            } catch _ {
            }
            return datemodv as? Date
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.contentModificationDateKey)
            } catch _ {
            }
        }
    }

    /// EZSE: File creation date, nil if file doesn't exist
    var fileCreationDate: Date? {
        get {
            var datecreatev: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&datecreatev, forKey: URLResourceKey.creationDateKey)
            } catch _ {
            }
            return datecreatev as? Date
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.creationDateKey)
            } catch _ {
            }

        }
    }

    /// EZSE: Returns last file access date, nil if file doesn't exist or not yet accessed
    var fileAccessDate: Date? {
        _ = URLResourceKey.customIconKey
        var dateaccessv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&dateaccessv, forKey: URLResourceKey.contentAccessDateKey)
        } catch _ {
        }
        return dateaccessv as? Date
    }

    /// EZSE: Returns file size, -1 if file doesn't exist
    var fileSize: Int64 {
        var sizev: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&sizev, forKey: URLResourceKey.fileSizeKey)
        } catch _ {
        }
        return sizev?.int64Value ?? -1
    }

    /// EZSE: File is hidden or not, don't care about files beginning with dot
    var fileIsHidden: Bool {
        get {
            var ishiddenv: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&ishiddenv, forKey: URLResourceKey.isHiddenKey)
            } catch _ {
            }
            return ishiddenv?.boolValue ?? false
        }
        set {
            do {
                try (self as NSURL).setResourceValue(newValue, forKey: URLResourceKey.isHiddenKey)
            } catch _ {
            }
            
        }
    }

    /// EZSE: Checks if file is writable
    var fileIsWritable: Bool {
        var isdirv: AnyObject?
        do {
            try (self as NSURL).getResourceValue(&isdirv, forKey: URLResourceKey.isWritableKey)
        } catch _ {
        }
        return isdirv?.boolValue ?? false
    }

    #if (OSX)
    @available(OSX 10.10, *)
    internal var fileThumbnailsDictionary: [String: NSImage]? {
        get {
            var thumbsData: AnyObject?
            do {
            try self.getResourceValue(&thumbsData, forKey: NSURLThumbnailDictionaryKey)
            } catch _ {
            }
            return thumbsData as? [String: NSImage]
        }
        set {
            do {
            let dic = NSDictionary(dictionary: newValue ?? [:])
            try self.setResourceValue(dic, forKey: NSURLThumbnailDictionaryKey)
            } catch _ {
            }
        }
    }

    /// EZSE: File thubmnail saved in system or iCloud in form of 1024pxx1024px
    @available(OSX 10.10, *)
    public var fileThumbnail1024px: NSImage? {
        get {
            return fileThumbnailsDictionary?[NSThumbnail1024x1024SizeKey]
        }
        set {
            assert(newValue == nil || (newValue?.size.height == 1024 && newValue?.size.width == 1024), "Image size set in fileThumbnail1024px is not 1024x1024")
            fileThumbnailsDictionary?[NSThumbnail1024x1024SizeKey] = newValue
        }
    }

    #else
    @available(iOS 8.0, *)
    internal var fileThumbnailsDictionary: [String: UIImage]? {
        get {
            var thumbsData: AnyObject?
            do {
                try (self as NSURL).getResourceValue(&thumbsData, forKey: URLResourceKey.thumbnailDictionaryKey)
            } catch _ {
            }
            return thumbsData as? [String: UIImage]
        }
        set {
            do {
                let dic = NSDictionary(dictionary: newValue ?? [:])
                try (self as NSURL).setResourceValue(dic, forKey: URLResourceKey.thumbnailDictionaryKey)
            } catch _ {
            }
        }
    }

    /// EZSE: File thubmnail saved in system or iCloud in form of 1024pxx1024px
    @available(iOS 8.0, *)
    var fileThumbnail1024px: UIImage? {
        get {
            return fileThumbnailsDictionary?[URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey.rawValue]
        }
        set {
            assert(newValue == nil || (newValue?.size.height == 1024 && newValue?.size.width == 1024), "Image size set in fileThumbnail1024px is not 1024x1024")
            fileThumbnailsDictionary?[URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey.rawValue] = newValue
        }
    }
    #endif

    /// EZSE: Set SkipBackup attrubute of file or directory in iOS. return current state if no value is set
    func skipBackupAttributeToItemAtURL(_ skip: Bool? = nil) -> Bool {
        let keys = [URLResourceKey.isDirectoryKey, URLResourceKey.fileSizeKey]
        let enumOpt = FileManager.DirectoryEnumerationOptions()
        if FileManager.default.fileExists(atPath: self.path) {
            if skip != nil {
                if self.fileIsDirectory {
                    let filesList = (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: keys, options: enumOpt)) ?? []
                    for fileURL in filesList {
                        _ = fileURL.skipBackupAttributeToItemAtURL(skip)
                    }
                }
                do {
                    try (self as NSURL).setResourceValue(NSNumber(value: skip! as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
                    return true
                } catch _ {
                    return false
                }
            } else {
                let dict = try? (self as NSURL).resourceValues(forKeys: [URLResourceKey.isExcludedFromBackupKey])
                if  let key: AnyObject = dict?[URLResourceKey.isExcludedFromBackupKey] as AnyObject? {
                    return key.boolValue
                }
                return false
            }
        }
        return false
    }
}

#endif




