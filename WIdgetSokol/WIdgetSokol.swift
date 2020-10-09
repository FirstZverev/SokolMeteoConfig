//
//  WIdgetSokol.swift
//  WIdgetSokol
//
//  Created by Володя Зверев on 09.10.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct WidgetModel: TimelineEntry {
    var date: Date
    var currentTime: String
}

struct DataProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetModel {
        let entry = WidgetModel(date: Date(), currentTime: "СОКОЛ-М")
        return entry

    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetModel>) -> Void) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        
        let time = formatter.string(from: date)
            
        let refresh  = Calendar.current.date(byAdding: .second, value: 10, to: date)!
        let entryData = WidgetModel(date: date, currentTime: time)

        let timeLine = Timeline(entries: [entryData], policy: .after(refresh))
        print("updated")
        
        completion(timeLine)
    }
    func getSnapshot(in context: Context, completion: @escaping (WidgetModel) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        
        let time = formatter.string(from: date)
        
        let entryData = WidgetModel(date: date, currentTime: time)
        
        completion(entryData)
    }
}

struct WidgetView: View {
    var data : DataProvider.Entry
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("СОКОЛ-М")
                
                Spacer()
                
            }
            .padding(.all)
            .background(Color.purple)
            Spacer()
            
            Text(data.currentTime)
                .padding(.horizontal, 15)
                .foregroundColor(.purple)
            
            Spacer()

        }
        .background(Color.white)
    }
}


@main
struct Config: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Widget", provider: DataProvider()) { data in
            WidgetView(data: data)
        }
        .supportedFamilies([.systemSmall])
        .description(Text("Current Time"))
    }
}


struct WIdgetSokol_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
