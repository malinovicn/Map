//
//  HttpStatusCode.swift
//  Map
//
//  Created by Nikola Malinovic on 25.03.21.
//

import Foundation

enum HttpStatusCode {
    case informational
    case success
    case redirect
    case clientError
    case serverError
    case unknown

    struct Range {
        static var informational: ClosedRange<Int> { 100...199 }
        static var success: ClosedRange<Int> { 200...299 }
        static var redirect: ClosedRange<Int> { 300...399 }
        static var clientError: ClosedRange<Int> { 400...499 }
        static var serverError: ClosedRange<Int> { 500...599 }
        static var unknown: ClosedRange<Int> { Int.min...Int.max }
    }

    init(code: Int) {
        switch code {
        case Range.informational:
            self = .informational
        case Range.success:
            self = .success
        case Range.redirect:
            self = .redirect
        case Range.clientError:
            self = .clientError
        case Range.serverError:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

extension Int {
    public var httpStatusSuccess: Bool {
        return HttpStatusCode(code: self) == .success
    }
    public var httpStatusClientError: Bool {
        return HttpStatusCode(code: self) == .clientError
    }
    public var httpStatusServerError: Bool {
        return HttpStatusCode(code: self) == .serverError
    }
}
