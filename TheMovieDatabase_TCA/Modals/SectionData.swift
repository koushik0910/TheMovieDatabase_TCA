//
//  SectionData.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import Foundation

struct SectionData: Identifiable, Equatable {
    let id: Section
    let title: String
    let data: [Movie]
}
