//
//  DetailsCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI
import NukeUI

struct DetailsCell: View {
    let media: Media
    
    var body: some View {
        VStack(spacing: 10){
            PosterView(backgroundImageURL: media.backdropFullPath, posterImageURL: media.posterFullPath)
            
            TitleAndUserScoreView(title: media.titleText, voteAverage: media.voteAverage, votingPercentage: media.votingPercentage)
            
            if let releaseDate = media.dateText{
                ReleaseDateView(releaseDate: releaseDate)
            }
            
            TaglineAndOverviewView(tagline: media.tagline, overview: media.overview)
        }
        .padding(.bottom)
        .foregroundStyle(.white)
        .background(.black.opacity(0.88))
    }
}

#Preview {
    DetailsCell(media: .mock)
}

struct PosterView: View {
    let backgroundImageURL: URL?
    let posterImageURL: URL?
    
    var body: some View {
        ZStack(alignment: .leading){
            LazyImage(url: backgroundImageURL){ state in
                if let image = state.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } else if state.error != nil {
                    Image("broken_image")
                } else {
                    ProgressView()
                }
            }
            .frame(height: 220)
            
            LazyImage(url: posterImageURL){ state in
                if let image = state.image {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Image("broken_image")
                } else {
                    ProgressView()
                }
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading)
        }
    }
}

struct TitleAndUserScoreView: View {
    let title: String?
    let voteAverage: Double
    let votingPercentage: String
    var body: some View {
        VStack(spacing: 10){
            if let title {
                Text(title)
                    .bold()
                    .font(.title2)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
            }
            
            HStack{
                ZStack{
                    Circle()
                        .frame(width: 45, height: 45)
                        .foregroundStyle(voteAverage > 7.0 ?  .green : .yellow)
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.black)
                    Text(votingPercentage)
                        .fontWeight(.semibold)
                        .font(.footnote)
                }
                Text("User Score")
            }
        }
    }
}

struct ReleaseDateView: View {
    let releaseDate: String
    var body: some View {
        HStack{
            Text(releaseDate)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(.black)
    }
}

struct TaglineAndOverviewView: View {
    let tagline: String?
    let overview: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            if let tagline{
                Text(tagline).italic()
            }
            VStack(alignment: .leading, spacing: 10){
                Text("Overview")
                    .bold()
                    .font(.title2)
                
                Text(overview)
            }
        }
        .padding(.horizontal)
    }
}

