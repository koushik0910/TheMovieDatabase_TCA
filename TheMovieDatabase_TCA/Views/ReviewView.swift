//
//  ReviewView.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 06/04/24.
//

import SwiftUI

struct ReviewView: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            
            AuthorDetailsView(profilePath: review.authorDetails.fullAvatarPath, username: review.authorDetails.username, rating: review.authorDetails.ratingText)
            }
        
            Text(review.content)
        }
}

#Preview {
    ReviewView(review: Review.mockData())
}

struct AuthorDetailsView: View {
    let profilePath : String?
    let username: String
    let rating: String
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            AuthorImageView(profilePath: profilePath)
            
            VStack(alignment: .leading, spacing: 5){
                Text("A review by \(username)")
                    .bold()
                
                HStack(spacing: 5){
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                    Text(rating)
                        .font(.footnote)
                }
                .foregroundStyle(.white)
                .frame(width: 60, height: 22)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 11))
            }
            
            Spacer()
        }
    }
}

struct AuthorImageView: View {
    let profilePath : String?
    var body: some View {
        VStack{
            if let profilePath {
                AsyncImage(url: URL(string: profilePath)!) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }else{
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 50, height: 50)
        .background(.gray)
        .clipShape(Circle())
    }
}

