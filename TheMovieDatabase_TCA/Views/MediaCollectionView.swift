//
//  MovieCollectionView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MediaCollectionView: View {
    let mediaArray: IdentifiedArrayOf<Media>
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(mediaArray) { media in
                    NavigationLink(state: DetailsViewReducer.State(media: media)) {
                        MediaCell(title: media.titleText, imageURL: media.posterFullPath, releaseDate: media.dateText)
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MediaCollectionView(mediaArray: [Media.mockData()])
}
