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
            if let castDetails = viewStore.cast, !castDetails.isEmpty {
                CastDetailsView(casts: castDetails)
            }
            
            if let reviews = viewStore.reviews, let review = reviews.first{
                SocialView(review: review)
            }
        }
        .task {
            viewStore.send(.fetchCastAndReviewDetails)
        }
        .toolbar {
            Button(action: {
                viewStore.send(.favouriteButtonTapped)
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

struct CastDetailsView: View {
    let casts: [Cast]
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Casts")
                .bold()
                .font(.title2)
                .padding(.leading)
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 15){
                    ForEach(casts) {cast  in
                        CastView(cast: cast)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
       
    }
}

struct SocialView: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Social")
                .bold()
                .font(.title2)
            
            ReviewView(review: review)
        }
        .padding(.horizontal)
    }
}


