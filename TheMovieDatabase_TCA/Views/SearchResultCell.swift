//
//  SearchResultCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI

struct SearchResultCell: View {
    let title: String
    let imageURLString: String
    let overview: String
    
    var body: some View {
        HStack(spacing: 10){
            AsyncImage(url: URL(string: imageURLString)) { poster in
                poster
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
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
    SearchResultCell(title: Movie.mockData().titleText, imageURLString: Movie.mockData().posterFullPath, overview: Movie.mockData().overview)
}
