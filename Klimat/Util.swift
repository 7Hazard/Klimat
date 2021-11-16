//
//  Util.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

func parseDate(_ isoDate: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from:isoDate)!
    return date;
}
