//
//  ISO8601CodingStrategy.swift
//
//
//  Created by Derek Clarkson on 10/1/2024.
//

import Foundation

/// Sets up the ``DateFormatter`` used for decoding and encoding date strings.
public protocol DateStringConfigurator {

    /// Called when setting up to decode or encode a date string.
    static func configure(formatter: DateFormatter)
}

/// Useful common configurations of date formatters.
public enum DateStringConfig {

    public enum ISO: DateStringConfigurator {
        public static func configure(formatter: DateFormatter) {
            formatter.dateFormat = "yyyy-MM-dd"
        }
    }

    public enum DMY: DateStringConfigurator {
        public static func configure(formatter: DateFormatter) {
            formatter.dateFormat = "dd/MM/yyyy"
        }
    }

    public enum MDY: DateStringConfigurator {
        public static func configure(formatter: DateFormatter) {
            formatter.dateFormat = "MM/dd/yyyy"
        }
    }
}
