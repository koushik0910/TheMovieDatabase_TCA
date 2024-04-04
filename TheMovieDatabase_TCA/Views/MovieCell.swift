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
            
            ZStack(alignment: .bottomLeading){
                AsyncImage(url: URL(string: imageURLString)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 160, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.middle)
                
                Text(releaseDate)
                    .fontWeight(.regular)
            }
            .foregroundStyle(.black)
            
            Spacer()
            
        }
        .frame(width: 160, height: 350)
    }
}

#Preview {
    MovieCell(title: Movie.mockData().title!, imageURLString:  Movie.mockData().posterFullPath, releaseDate: Movie.mockData().dateText)
}
