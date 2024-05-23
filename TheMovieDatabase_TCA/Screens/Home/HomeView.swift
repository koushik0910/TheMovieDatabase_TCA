//
//  HomeView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var viewStore: StoreOf<HomeViewReducer>
    
    var body: some View {
        NavigationStack(path: $viewStore.scope(state: \.path, action: \.path)){
            ScrollView{
                if viewStore.searchQuery.isEmpty {
                    ForEach(viewStore.sections){ section in
                        HorizontalMediaView(section: section)
                    }
                }else{
                    VerticalSearchView(mediaArray: viewStore.searchedResults)
                }
            }
            .navigationTitle("TMDB")
            .searchable(text: $viewStore.searchQuery.sending(\.searchQueryChanged))
            .task {
                viewStore.send(.fetchData)
            }
            .task(id: viewStore.searchQuery) {
                do{
                    try await Task.sleep(for: .milliseconds(300))
                    await viewStore.send(.searchQueryChangeDebounced).finish()
                }catch { }
            }
        }destination: { store in
            DetailsView(viewStore: store)
        }
    }
}

#Preview {
    HomeView(viewStore: Store(initialState: HomeViewReducer.State(), reducer: { HomeViewReducer() }))
}

struct HorizontalMediaView: View {
    let section: HomeSectionData
    
    var body: some View {
        VStack(alignment:.leading){
            Text(section.title)
                .bold()
                .font(.title2)
                .padding()
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    if let mediaArray = section.data {
                        ForEach(mediaArray) { media in
                            NavigationLink(state: DetailsViewReducer.State(media: media)) {
                                MediaCell(title: media.titleText, imageURL: media.posterFullPath, releaseDate: media.dateText)
                            }
                        }
                    }else{
                        ErrorCell()
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct VerticalSearchView: View {
    let mediaArray: IdentifiedArrayOf<Media>
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(mediaArray) { media in
                    NavigationLink(state: DetailsViewReducer.State(media: media)) {
                        SearchResultCell(title: media.titleText, imageURL: media.posterFullPath, overview: media.overview)
                    }
                }
            }
        }
    }
}


struct ErrorCell: View {
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Image("error")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                
                Text("Opps! Something went wrong")
                    .foregroundStyle(.gray)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}
