//
//  SectionData.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

struct SectionData: Identifiable, Equatable {
    var id: String { UUID().uuidString }
    let title: String
    let data: [Movie]
    
    static func == (lhs: SectionData, rhs: SectionData) -> Bool {
        lhs.id == rhs.id
    }
}
