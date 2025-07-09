//
//  DetectionManager.swift
//  Calorizz
//
//  Created by Foundation-021 on 09/07/25.
//

import UIKit
import Vision
import CoreML

class DetectionManager {
    static let shared = DetectionManager()

    private let visionModel: VNCoreMLModel?
    private let model: FoodDetection1?

    /// Label diambil langsung dari metadata model
    private lazy var labels: [String] = {
        guard let model = model else { return [] }
        guard let userDefined = model.model.modelDescription.metadata[.creatorDefinedKey] as? [String: String],
              let allLabels = userDefined["classes"] else {
            print("⚠️ Label metadata tidak ditemukan di model.")
            return []
        }
        let parsedLabels = allLabels.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        print("✅ Label dari model: \(parsedLabels)")
        return parsedLabels
    }()

    private init() {
        if let model = try? FoodDetection1(configuration: MLModelConfiguration()) {
            self.model = model
            self.visionModel = try? VNCoreMLModel(for: model.model)
        } else {
            self.model = nil
            self.visionModel = nil
        }
    }

    /// Deteksi label dari gambar menggunakan Vision & CoreML
    func detectLabels(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let visionModel = visionModel else {
            print("❌ Model tidak tersedia.")
            completion([])
            return
        }

        guard let ciImage = CIImage(image: image) else {
            print("❌ Gagal konversi UIImage ke CIImage.")
            completion([])
            return
        }

        let request = VNCoreMLRequest(model: visionModel) { request, error in
            if let error = error {
                print("❌ VNCoreMLRequest error: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("❌ Tidak ada hasil yang valid.")
                completion([])
                return
            }

            let detectedLabels = results.compactMap { observation -> String? in
                guard let topLabel = observation.labels.first,
                      topLabel.confidence > 0.4 else {
                    return nil
                }
                print("📦 Detected: \(topLabel.identifier) (\(topLabel.confidence))")
                return topLabel.identifier
            }

            completion(detectedLabels)
        }

        // Atur parameter tambahan jika diperlukan
        request.imageCropAndScaleOption = .scaleFill

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Gagal melakukan deteksi: \(error)")
                completion([])
            }
        }
    }
}
