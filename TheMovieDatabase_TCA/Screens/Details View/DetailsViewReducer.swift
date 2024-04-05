//
//  DetailsView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailsViewReducer {
    
  @ObservableState
  struct State: Equatable {
    let movie: Movie
  }
    
  enum Action {
  }
    
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      }
    }
  }
}
