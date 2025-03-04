//
//  ImmersiveView.swift
//  HoverSoundBug
//
//  Created by Brian Elliott on 3/4/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        RealityView { content, attachments in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
            
            if let controls = try? await Entity(named: "Controls", in: realityKitContentBundle) {
                content.add(controls)
                controls.transform.translation = SIMD3<Float>(0.0, 0.1, -2.0)
            }
            
            if let testButton = attachments.entity(for: "Test ID") {
                testButton.position = SIMD3<Float>(-0.5, 1.0, -1.0)
                content.add(testButton)
            }
        } attachments: {
            Attachment(id: "Test ID"){
                VStack {
                    Button {
                        print("Test picked")
                    } label: {
                        Label("Test", systemImage: "house")
                            .font(.extraLargeTitle)
                    }
                    .frame(width: 250, height: 250)
                }
            }
        }
        .simultaneousGesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    let entity = value.entity
                    let name = entity.name
                    print("gesture tapped \(name)")
                }
        )
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
