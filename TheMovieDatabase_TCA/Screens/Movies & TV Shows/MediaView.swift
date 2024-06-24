//
//  MoviesView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MediaView: View {
    @Bindable var viewStore: StoreOf<MediaViewReducer>
    var body: some View {
        NavigationStack(path: $viewStore.scope(state: \.path, action: \.path)){
            MediaCollectionView(mediaArray: viewStore.mediaArray)
                .task(id: viewStore.currentSortOrder){
                    viewStore.send(.fetchData)
                }
                .toolbar {
                    SortToolBarContent { order in
                        viewStore.send(.sortOrderChanged(order))
                    }
                }
                .navigationTitle(viewStore.currentSortOrder.rawValue)
        }destination: { store in
            DetailsView(viewStore: store)
        }
        .alert($viewStore.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    MediaView(viewStore: Store(initialState: MediaViewReducer.State(mediaType: .movie), reducer: {
        MediaViewReducer()
    }))
}


struct SortToolBarContent: ToolbarContent {
    var action: (MediaSortOrder) -> ()
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu(content: {
                ForEach(MediaSortOrder.allCases, id: \.hashValue){ order in
                    Button(order.rawValue){
                        action(order)
                    }
                }
            }, label: {Text("Sort")})
        }
    }
}
