//
//  HandView.swift
//  HoloSync
//
//  Created by Patron on 10/6/25.
//

import SwiftUI

struct HandView: View {
    // State variable to hold all the parsed hand data frames
    @State private var handFrames: [Hand] = []

    var body: some View {
        VStack {
            // A title for the view
            Text("Hand Data Frames")
                .font(.largeTitle)
                .padding()

            // Check if the data has been loaded
            if handFrames.isEmpty {
                // Show a message while loading or if loading fails
                Text("Loading data...")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                // If data is loaded, display it in a scrollable list
                List(handFrames.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        // Display info for each frame
                        Text("Frame \(index)")
                            .font(.headline)
                        
                        // Show the timestamp and chirality (left/right hand)
                        Text("  - Timestamp: \(handFrames[index].t_mono, specifier: "%.2f")")
                        Text("  - Chirality: \(handFrames[index].chirality)")
                        
                        // --- MODIFIED SECTION ---
                        // A new sub-section for finger tip positions
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Finger Tip Positions (X, Y, Z):")
                                .font(.subheadline.bold())
                                .padding(.top, 5)

                            // Safely unwrap and display the position for each finger tip
                            if let thumb = handFrames[index].joints["thumbTip"] {
                                Text("  - Thumb:  (\(thumb.position.x, specifier: "%.3f"), \(thumb.position.y, specifier: "%.3f"), \(thumb.position.z, specifier: "%.3f"))")
                            }
                            if let index = handFrames[index].joints["indexFingerTip"] {
                                Text("  - Index:  (\(index.position.x, specifier: "%.3f"), \(index.position.y, specifier: "%.3f"), \(index.position.z, specifier: "%.3f"))")
                            }
                            if let middle = handFrames[index].joints["middleFingerTip"] {
                                Text("  - Middle: (\(middle.position.x, specifier: "%.3f"), \(middle.position.y, specifier: "%.3f"), \(middle.position.z, specifier: "%.3f"))")
                            }
                            if let ring = handFrames[index].joints["ringFingerTip"] {
                                Text("  - Ring:   (\(ring.position.x, specifier: "%.3f"), \(ring.position.y, specifier: "%.3f"), \(ring.position.z, specifier: "%.3f"))")
                            }
                            if let little = handFrames[index].joints["littleFingerTip"] {
                                Text("  - Little: (\(little.position.x, specifier: "%.3f"), \(little.position.y, specifier: "%.3f"), \(little.position.z, specifier: "%.3f"))")
                            }
                        }
                        .font(.footnote) // Use a smaller font to keep it clean
                        
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            // When the view appears, call our parsing function
            self.handFrames = HandDataParser.parse(csvFileName: "hand_data_pivoted 3")
            
            print("Loaded \(handFrames.count) frames from CSV.")
            print(self.handFrames[1])
        }
    }
}

// MARK: - Preview

struct HandView_Previews: PreviewProvider {
    static var previews: some View {
        // The preview will just show the "Loading..." state,
        // as it cannot access the app's bundled files.
        HandView()
    }
}
