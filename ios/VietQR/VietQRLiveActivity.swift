//
//  VietQRLiveActivity.swift
//  VietQR
//
//  Created by Lê Nguyên on 22/4/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct VietQRAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct VietQRLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: VietQRAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension VietQRAttributes {
    fileprivate static var preview: VietQRAttributes {
        VietQRAttributes(name: "World")
    }
}

extension VietQRAttributes.ContentState {
    fileprivate static var smiley: VietQRAttributes.ContentState {
        VietQRAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: VietQRAttributes.ContentState {
         VietQRAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: VietQRAttributes.preview) {
   VietQRLiveActivity()
} contentStates: {
    VietQRAttributes.ContentState.smiley
    VietQRAttributes.ContentState.starEyes
}
