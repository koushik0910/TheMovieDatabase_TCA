//
//  MovieCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 04/04/24.
//

import SwiftUI
import NukeUI

struct MediaCell: View {
    let title: String?
    let imageURL: URL?
    let releaseDate: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyImage(url: imageURL){ state in
                if let image = state.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } else if state.error != nil {
                    Image("broken_image")
                } else {
                    ProgressView()
                }
            }
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading){
                if let title {
                    Text(title)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.middle)
                }
                
                if let releaseDate {
                    Text(releaseDate)
                }
            }
            .font(.callout)
            .foregroundStyle(.black)
            
            Spacer()
            
        }
        .frame(width: 150)
    }
}

#Preview {
    MediaCell(title: Media.mock.title!, imageURL:  Media.mock.posterFullPath, releaseDate: Media.mock.dateText)
}
