//
//  URLRequest+Additions.swift
//  Map
//
//  Created by Nikola Malinovic on 25.03.21.
//

import Combine
import Foundation

/// Utility top level function to apply modifiers and return a modified instance
public func modifying<T>(_ value: T, with closure: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}

public extension URL {
    /// Creates  a request from this `URL`.
    /// - Parameter path: An optional path to append to the URL
    /// - Parameter method: An optional HTTP method, `.get` by default
    /// - Returns: a `URLRequest`
    func request(_ method: URLRequest.Method = .get, path: String? = nil) -> URLRequest {
        if let path = path, !path.isEmpty {
            return URLRequest(url: appendingPathComponent(path)).with(method: method)
        }
        return URLRequest(url: self).with(method: method)
    }
}

/// URLRequest modifiers
public extension URLRequest {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case head = "HEAD"
        case patch = "PATCH"
    }

    /// Returns a request with modified parameters
    func adding(parameters: URL.Parameters) -> Self {
        modifying(self) { $0.url = $0.url?.adding(parameters: parameters) }
    }

    /// Returns a new request with modified headers. Any existing headers with the same name are overwritten.
    func adding(headers: [String: String]) -> Self {
        modifying(self) {
            $0.allHTTPHeaderFields = ($0.allHTTPHeaderFields ?? [:]).merging(headers) { _, other in other }
        }
    }

    /// Returns a new request with a modified header. Any existing header with the same name is overwritten.
    func adding(header: String, value: String) -> Self {
        adding(headers: [header: value])
    }

    /// Returns a request with a modified HTTP method.
    func with(method: Method) -> Self {
        modifying(self) { $0.httpMethod = method.rawValue }
    }

    /// Returns a new request with a modified HTTP body.
    /// - Parameter body: A plain string body
    func with(body: String) -> Self {
        modifying(self) { $0.httpBody = body.data(using: .utf8) }
    }

    /// Returns a new request with a modified HTTP body and `Content-Type` header.
    /// - Parameter body: Any `Encodable` type
    /// - Parameter encoder: An optional `JSONEncoder`
    func with<T: Encodable>(body: T, encoder: JSONEncoder = .shared) -> Self {
        modifying(self) {
            $0.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            $0.httpBody = try? encoder.encode(body)
        }
    }

    /// Returns a new request with a modified HTTP body and `Content-Type` header.
    /// - Parameter body: A dictionary or parameters
    func with(body: URL.Parameters) -> Self {
        modifying(self) {
            $0.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            $0.httpBody = body.queryString?.data(using: .utf8)
        }
    }

    /// Returns a new request with a modified HTTP body.
    /// - Parameter body: Any `Encodable` type
    /// - Parameter encoder: A custom encoder
    func with<T: Encodable, E: TopLevelEncoder>(body: T, encoder: E) -> Self where E.Output == Data {
        modifying(self) {
            $0.httpBody = try? encoder.encode(body)
        }
    }

    /// Returns a new request with a modified `User-Agent` header.
    /// - Parameter userAgent: The new user-agent string
    func with(userAgent: String) -> Self {
        adding(header: "User-Agent", value: userAgent)
    }
}

extension URLRequest {
    /// Prints request's description in debug mode
    func debugPrintRequest() {
        #if DEBUG
        print(requestInfo)
        #endif
    }
    private var requestInfo: String {
        var result = "==== HTTP Request ====\n"
        if let method = httpMethod {
            result += "\(method) "
        }
        if let url = url {
            result += "\(url.absoluteString)\n"
        }
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "==== Header Fields ====\n"
                result += "\"\(header): \(value)\"\n"
            }
        }
        if let body = httpBody, !body.isEmpty,
           let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "==== Request Body ====\n"
            result += "\(string)\n"
        }
        return result
    }
}

/// Extension used for decoding data to Date representation
public extension ISO8601DateFormatter {
    /// Decodes dates with the RFC 3339 representation, without fractional seconds, e.g. "2020-06-03T14:43:05Z"
    static let rfc3339 = modifying(ISO8601DateFormatter()) {
        $0.formatOptions = [.withInternetDateTime]
    }

    /// Decodes dates with the RFC 3339 representation, with fractional seconds, e.g. "2020-06-03T14:43:05.913Z"
    static let rfc3339withFractionalSeconds = modifying(ISO8601DateFormatter()) {
        $0.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    /// Decodes dates with the RFC 3339 representation, without time, e.g. "2020-07-18"
    static let rfc3339withFullDate = modifying(ISO8601DateFormatter()) {
        $0.formatOptions = [.withFullDate]
    }
}

public extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withOptionalFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        // Try both with and without fractional seconds
        guard let date = ISO8601DateFormatter.rfc3339withFractionalSeconds.date(from: string)
            ?? ISO8601DateFormatter.rfc3339.date(from: string)
            ?? ISO8601DateFormatter.rfc3339withFullDate.date(from: string)
        else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        return date
    }
}

public extension JSONDecoder {
    /// A convenient, shared `JSONDecoder`
    static let shared = modifying(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .iso8601withOptionalFractionalSeconds
    }
}

public extension JSONEncoder {
    /// A convenient, shared `JSONEncoder`
    static let shared = modifying(JSONEncoder()) {
        $0.dateEncodingStrategy = .iso8601
    }
}

public extension URLRequest {
    /// Creates a publisher for this request and decodable type.
    ///
    /// Example:
    ///
    ///     func employee(name: String) -> AnyPublisher<Employee, Error> {
    ///         URL(string: "https://api.foo.com/employees")!
    ///             .getRequest(path: name).publisher()
    ///     }
    /// - Parameter session: Optional session. `URLSession.shared` is used by default.
    /// - Parameter decoder: Optional decoder. `JSONDecoder.shared` is used by default.
    /// - Returns: A publisher that wraps a data task and decoding for the URL request
    ///
    func publisher<T: Decodable>(
        session: URLSession = .shared, decoder: JSONDecoder = .shared
    ) -> AnyPublisher<T, Error> {
        debugPrintRequest()
        return session.dataTaskPublisher(for: self)
            .tryMap { data, response -> JSONDecoder.Input in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                    let apiError = try decoder.decode(APIError.self, from: data)
                    throw apiError
                }
                return data
            }
            .map { $0.debugPrintAsJSON() }
            .decode(type: T.self, decoder: decoder)
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    debugPrint(error)
                }
            })
            .eraseToAnyPublisher()
    }

    /// Publishes just the HTTP status of this request
    func statusPublisher(
        session: URLSession = .shared, decoder: JSONDecoder = .shared
    ) -> AnyPublisher<Int?, Error> {
        debugPrintRequest()
        return session.dataTaskPublisher(for: self)
            .tryMap {
                guard let response = ($0.response as? HTTPURLResponse),
                      HttpStatusCode.Range.success.contains(response.statusCode) else {
                    throw AlertError.unauthorized
                }
                return response.statusCode
            }
            .eraseToAnyPublisher()
    }
}

public struct APIError: Error, Equatable, Decodable {
    var status: Int // TODO: Change this in API from string to int
    public let title, detail, code, correctedValue, fieldName, type, message, timestamp, path, error: String?

    var localizedDescription: String? {
        detail
    }
}

extension Data {
    @discardableResult func debugPrintAsJSON() -> Self {
        #if DEBUG
            print("==== JSON Dump ====")
            guard let object = try? JSONSerialization.jsonObject(with: self),
                let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
                let json = String(data: data, encoding: .utf8)
            else {
                print(String(data: self, encoding: .utf8) ?? "Unknown data encoding")
                return self
            }
            print(json)
        #endif
        return self
    }
}
