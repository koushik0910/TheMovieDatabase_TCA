//
//  DetailsCell.swift
//  TheMovieDatabase_TCA
//
//  Created by Koushik Dutta on 05/04/24.
//

import SwiftUI

struct DetailsCell: View {
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 10){
            PosterView(backgroundImageURLString: movie.backdropFullPath, posterImageURLString: movie.posterFullPath)
            
            TitleAndUserScoreView(title: movie.titleText, voteAverage: movie.voteAverage, votingPercentage: movie.votingPercentage)
            
            ReleaseDateView(releaseDate: movie.dateText)
            
            TaglineAndOverviewView(tagline: movie.tagline, overview: movie.overview)
        }
        .padding(.bottom)
        .foregroundStyle(.white)
        .background(.black.opacity(0.88))
    }
}

#Preview {
    DetailsCell(movie: Movie.mockData())
}

struct PosterView: View {
    let backgroundImageURLString: String
    let posterImageURLString: String
    
    var body: some View {
        ZStack(alignment: .leading){
            AsyncImage(url: URL(string: backgroundImageURLString)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 220)
            
            AsyncImage(url: URL(string: posterImageURLString)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading)
        }
    }
}

struct TitleAndUserScoreView: View {
    let title: String
    let voteAverage: Double
    let votingPercentage: String
    var body: some View {
        VStack(spacing: 10){
            Text(title)
                .bold()
                .font(.title2)
                .foregroundStyle(Color.white)
            
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
