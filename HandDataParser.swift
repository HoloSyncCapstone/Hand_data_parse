// HandDataParser.swift

import Foundation
import simd

// Represents a 3D vector./location in 3D space
struct Vector3 {
    let x: Double
    let y: Double
    let z: Double
}

// Represents a quaternion for orientation./ rotation in 3D space
struct Quaternion {
    let x: Double
    let y: Double
    let z: Double
    let w: Double
}

// Represents a single joint with position and orientation.
struct Joint {
    let position: Vector3
    let orientation: Quaternion
}

// Represents a single row of hand data from the CSV.
struct Hand {
    let t_mono: Double // moment in time /frames
    let t_wall: Double // real time
    let chirality: String //left or right
    let joints: [String: Joint] //all the joints
}

// A class to handle parsing of the CSV data.
class HandDataParser {
    
    // Parses the hand data CSV and returns an array of Hand objects.
    static func parse(csvFileName: String) -> [Hand] {
        var hands = [Hand]()
        
        // Ensure the file exists in the bundle.
        guard let fileURL = Bundle.main.url(forResource: csvFileName, withExtension: "csv") else {
            print("CSV file not found.")
            return hands
        }
        
        do {
            let data = try String(contentsOf: fileURL)
            let rows = data.components(separatedBy: "\n")
            
            // Skip the header row.
            for row in rows.dropFirst() {
                let columns = row.components(separatedBy: ",")
                if columns.count > 1 {
                    
                    let t_mono = Double(columns[0]) ?? 0.0
                    let t_wall = Double(columns[1]) ?? 0.0
                    let chirality = columns[2]
                    
                    var joints = [String: Joint]()
                    
                    // --- MODIFIED SECTION ---
                    // Added "forearmArm" and "forearmWrist" to the list of joints to be parsed.
                    // The order here must match the order of columns in your CSV file.
                    let jointNames = [
                        "forearmArm", "forearmWrist",
                        "thumbKnuckle", "thumbIntermediateBase", "thumbIntermediateTip", "thumbTip",
                        "indexFingerMetacarpal", "indexFingerKnuckle", "indexFingerIntermediateBase", "indexFingerIntermediateTip", "indexFingerTip",
                        "middleFingerMetacarpal", "middleFingerKnuckle", "middleFingerIntermediateBase", "middleFingerIntermediateTip", "middleFingerTip",
                        "ringFingerMetacarpal", "ringFingerKnuckle", "ringFingerIntermediateBase", "ringFingerIntermediateTip", "ringFingerTip",
                        "littleFingerMetacarpal", "littleFingerKnuckle", "littleFingerIntermediateBase", "littleFingerIntermediateTip", "littleFingerTip"
                    ]
                    
                    var i = 3 // Start parsing from the 4th column
                    for jointName in jointNames {
                        // Ensure there are enough columns left for a full joint (px,py,pz,qx,qy,qz,qw)
                        if i + 6 < columns.count {
                            let position = Vector3(x: Double(columns[i]) ?? 0.0, y: Double(columns[i+1]) ?? 0.0, z: Double(columns[i+2]) ?? 0.0)
                            let orientation = Quaternion(x: Double(columns[i+3]) ?? 0.0, y: Double(columns[i+4]) ?? 0.0, z: Double(columns[i+5]) ?? 0.0, w: Double(columns[i+6]) ?? 0.0)
                            joints[jointName] = Joint(position: position, orientation: orientation)
                            i += 7 // Move to the next set of 7 columns
                        }
                    }
                    
                    let hand = Hand(t_mono: t_mono, t_wall: t_wall, chirality: chirality, joints: joints)
                    hands.append(hand)
                }
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }
        
        return hands
    }
}
