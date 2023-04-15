//
//  SlidingCard.swift
//  movie3
//
//  Created by Obuka on 6.4.23..
//

import SwiftUI
import Foundation

struct SlidingCard: View {
    let trendingItem: Movie

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: trendingItem.poster) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 145)
            } placeholder: {
                Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                        .frame(width: 145, height: 210)
            }

            
            .background(Color(red:61/255,green:61/255,blue:88/255))
        }
        .cornerRadius(10)
    }
}

struct SlidingCard_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
