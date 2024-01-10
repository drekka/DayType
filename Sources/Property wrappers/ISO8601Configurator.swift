//
//  ISO8601CodingStrategy.swift
//
//
//  Created by Derek Clarkson on 10/1/2024.
//

import Foundation

/// Sets up the ``ISO8601DateFormatter`` used for decoding and encoding date strings.
public protocol ISO8601Configurator {

    /// Called whens etting up to decode or encode an ISO8601 date string.
    static func configure(formatter: ISO8601DateFormatter)
}

/// A default implementation of a ``ISO8601CodingStrategy`` that's used
/// in the default property wrappers.
public enum ISO8601DefaultConfigurator: ISO8601Configurator {
    public static func configure(formatter _: ISO8601DateFormatter) {}
}
