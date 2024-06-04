//
//  SearchResultCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import NukeUI

struct SearchResultCell: View {
    let title: String?
    let imageURL: URL?
    let overview: String
    
    var body: some View {
        HStack(spacing: 10){
            LazyImage(url: imageURL){ state in
                if let image = state.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Image("broken_image")
                } else {
                    ProgressView()
                }
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading){
                if let title {
                    Text(title)
                        .font(.headline)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                }
                
                Text(overview)
                    .font(.caption)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchResultCell(title: Media.mock.titleText, imageURL: Media.mock.posterFullPath, overview: Media.mock.overview)
}
