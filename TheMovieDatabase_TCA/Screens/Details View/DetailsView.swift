//
//  DetailsView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailsView: View {
    let viewStore: StoreOf<DetailsViewReducer>
    
    var body: some View {
        ScrollView{
            DetailsCell(movie: viewStore.movie)
        }
        .toolbar {
            Button(action: {
                
            }, label: {
                Image(systemName: "heart")
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    DetailsView(viewStore: Store(initialState: DetailsViewReducer.State(movie: Movie.mockData()), reducer: {
        DetailsViewReducer()
    }))
}
