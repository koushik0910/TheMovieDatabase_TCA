//
//  FavouritesView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI
import ComposableArchitecture

struct FavouritesView: View {
    @Bindable var viewStore: StoreOf<FavouritesViewReducer>
    
    var body: some View {
        NavigationStack(path: $viewStore.scope(state: \.path, action: \.path)){
            MediaCollectionView(mediaArray: viewStore.userFavourites)
                .navigationTitle("Favourites")
        }destination: { store in
            DetailsView(viewStore: store)
        }
    }
}

#Preview {
    FavouritesView(viewStore: Store(initialState: FavouritesViewReducer.State(), reducer: {
        FavouritesViewReducer()
    }))
}
