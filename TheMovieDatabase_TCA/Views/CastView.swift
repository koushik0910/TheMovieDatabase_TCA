//
//  CastView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI

struct CastView: View {
    var cast: Cast
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            VStack(alignment: .leading){
                CastImageView(profileImagePath: cast.fullProfilePath)
            
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
    let profileImagePath: String?
    var body: some View {
        VStack(alignment: .leading){
            if let profileImagePath {
                AsyncImage(url: URL(string: profileImagePath)!) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }else{
                Image("person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: 110, height: 130)
        .padding(.bottom)
    }
}
