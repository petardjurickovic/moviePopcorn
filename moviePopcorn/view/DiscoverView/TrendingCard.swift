//
//  TrendingCard.swift
//  movie3
//
//  Created by Obuka on 5.4.23..
//


import Foundation
import SwiftUI

struct TrendingCard: View {

    let trendingItem: Movie

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: trendingItem.poster) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 145, height: 210)
            } placeholder: {
                Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                        .frame(width: 145, height: 210)
            }

            
            .background(Color(red:61/255,green:61/255,blue:88/255))
        }
        .cornerRadius(10)
    }
}
struct TrendingCard_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
