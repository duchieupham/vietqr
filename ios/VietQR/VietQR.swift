//
//  VietQR.swift
//  VietQR
//
//  Created by Lê Nguyên on 22/4/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

// func generateQRCode(from string: String) -> UIImage {
//     let context = CIContext()
//     let filter = CIFilter.qrCodeGenerator()
//     let data = Data(string.utf8)
//     filter.setValue(data, forKey: "inputMessage")
    
//     if let outputImage = filter.outputImage {
//         if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
//             return UIImage(cgImage: cgimg)
//         }
//     }
//     return UIImage(systemName: "xmark.circle") ?? UIImage() // Fallback image
// }

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct VietQREntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // VStack {
        //     Text("hello anh Hiếu,")

        //     Text("Em khong biet swift =)))")
        //     Text(entry.configuration.favoriteEmoji)
        // }
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Xin chào anh Hiếu,")
                Text("Em đang học Swift.")
                Text(entry.configuration.favoriteEmoji)
            }
            Spacer()
            // Image(uiImage: generateQRCode(from: "Hello, SwiftUI!"))
            //     .resizable()
            //     .scaledToFit()
            //     .frame(width: 50, height: 50)  // Adjust the size as needed
        }
        .padding()
    }
}

struct VietQR: Widget {
    let kind: String = "VietQR"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            VietQREntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    VietQR()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
