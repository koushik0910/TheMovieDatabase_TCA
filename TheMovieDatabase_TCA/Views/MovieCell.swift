//
//  MovieCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI

struct MovieCell: View {
    let title: String
    let imageURLString: String
    let releaseDate: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: imageURLString)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading){
                Text(title)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.middle)
                
                Text(releaseDate)
            }
            .font(.callout)
            .foregroundStyle(.black)
            
            Spacer()
            
        }
        .frame(width: 150)
    }
}

#Preview {
    MovieCell(title: Movie.mockData().title!, imageURLString:  Movie.mockData().posterFullPath, releaseDate: Movie.mockData().dateText)
}
