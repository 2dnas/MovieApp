//
//  MovieTimeFormatter.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 15.11.22.
//

import Foundation


final class MovieTimeFormatter {
    
    func minutesToHours(minutes: Int) -> String {
        
        let hours = minutes / 60
        let minute = minutes % 60
        
        if minutes < 0 {
            return "No Info"
        } else if minutes < 60 {
            return "\(minutes)m"
        } else if (minutes % 60) == 0 {
            return "\(hours)h"
        }
        
        
        return "\(hours)h \(minute)m"
    }
    
    //Time is comming YYYY-MM-SS format so we could cast it to Date and then use dateFormatter class
    //but its simplier and we don't have unnecessary dependency
    //Here function is simply getting first 4 letter of the string which generally will be year
    func getOnlyYearFromDate(date: String?) -> String {
        guard let date = date else { return "No Info"}
        return String(date.prefix(4))
    }
}
