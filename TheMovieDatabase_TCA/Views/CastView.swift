//
//  CastView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI
import NukeUI

struct CastView: View {
    var cast: Cast
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            VStack(alignment: .leading){
                CastImageView(profileImageURL: cast.fullProfilePath)
            
                VStack(alignment: .leading, spacing: 0){
                    Text(cast.name)
                        .fontWeight(.semibold)
                    Text(cast.character ?? "")
                        .foregroundStyle(.gray)
                }
                .font(.footnote)
                .padding(.horizontal, 5)
                
                Spacer()
            }
        }
        .frame(width: 110, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray ,radius: 2)
        .padding(.vertical)
    }
}

#Preview {
    CastView(cast: Cast.mockData())
}

struct CastImageView: View {
    let profileImageURL: URL?
    var body: some View {
        VStack(alignment: .leading){
            LazyImage(url: profileImageURL){ state in
                if let image = state.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("person")
                }
            }
        }
        .frame(width: 110, height: 130)
        .padding(.bottom)
    }
}
