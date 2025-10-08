//
//  QRUtil.swift
//  Pods
//
//  Created by Mauricio Castillo on 07-10-25.
//
import UIKit
import Vision
import ImageIO
import CoreImage

/// Lector sincrónico: extrae una URL segura desde un QR en una UIImage.
/// Devuelve nil si no hay QR o si la URI es considerada no segura.
public func extractSafeURLFromQRSync(
    image: UIImage,
    blockedSchemes: Set<String> = ["javascript", "data", "file", "vbscript"],
    allowHTTP: Bool = false,
    allowLocalNetworkHosts: Bool = false,
    maxLength: Int = 2000,
    maxSideForDownscale: CGFloat = 2048,
    forceCPU: Bool? = nil   // nil = auto (simulador CPU; dispositivo GPU)
) -> URL? {
    func containsControlCharacters(_ s: String) -> Bool {
        for sc in s.unicodeScalars {
            if CharacterSet.controlCharacters.contains(sc) { return true }
            if sc.properties.isVariationSelector { return true }
        }
        return false
    }
    func isLocalOrPrivateIPv4(_ host: String) -> Bool {
        if host == "localhost" { return true }
        let p = host.split(separator: ".")
        guard p.count == 4,
              let a = UInt8(p[0]), let b = UInt8(p[1]),
              let c = UInt8(p[2]), let d = UInt8(p[3]) else { return false }
        _ = c; _ = d
        if a == 10 { return true }                         // 10.0.0.0/8
        if a == 172, (16...31).contains(b) { return true } // 172.16.0.0/12
        if a == 192, b == 168 { return true }              // 192.168.0.0/16
        if a == 127 { return true }                        // 127.0.0.0/8
        if a == 169, b == 254 { return true }              // 169.254.0.0/16
        return false
    }
    func cgOrientation(from o: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch o {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
    // Downscale/Upscale defensivo: crea SIEMPRE un CGImage propio (evita problemas de lifetime de UIImage)
    func resizedCGImage(from image: UIImage, targetSize: CGFloat) -> CGImage? {
        guard let baseCG = image.cgImage else { return nil }
        let w = CGFloat(baseCG.width), h = CGFloat(baseCG.height)
        let maxCurrent = max(w, h)

        // Si la imagen es muy pequeña (< 300px), hacer upscale
        let finalSize = maxCurrent < 300 ? max(targetSize, 512) : targetSize

        if abs(maxCurrent - finalSize) < 10 {
            // Similar tamaño, igual copiamos
            return baseCG.copy()
        }

        let scale = finalSize / maxCurrent
        let newW = Int(w * scale), newH = Int(h * scale)
        let cs = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: nil,
            width: newW, height: newH,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: cs,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return baseCG.copy() }
        // Para QR: usar interpolación none si estamos escalando hacia arriba (evita difuminado)
        ctx.interpolationQuality = scale > 1.5 ? .none : .high
        ctx.draw(baseCG, in: CGRect(x: 0, y: 0, width: newW, height: newH))
        return ctx.makeImage()
    }

    // Usar imagen ORIGINAL sin procesar
    guard let cgImage = image.cgImage else { return nil }

    // Forzar orientación .up para evitar problemas con Vision
    let orientation: CGImagePropertyOrientation = .up

    // Política CPU/GPU
    #if targetEnvironment(simulator)
    let useCPU = forceCPU ?? false
    #else
    let useCPU = forceCPU ?? false
    #endif

    // ---- Intentar con CIDetector primero (más robusto para QRs pequeños) ----
    let payload: String = autoreleasepool {
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        if let features = detector?.features(in: ciImage) as? [CIQRCodeFeature],
           let first = features.first,
           let message = first.messageString,
           !message.isEmpty {
            return message
        }

        // ---- Fallback a Vision ----
        let request = VNDetectBarcodesRequest()
        request.symbologies = [.QR]
        request.usesCPUOnly = useCPU

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: orientation,
            options: [:]
        )

        do {
            try handler.perform([request])
            if let results = request.results as? [VNBarcodeObservation],
               let first = results.first(where: { $0.symbology == .QR }),
               let text = first.payloadStringValue,
               !text.isEmpty {
                return text
            }
            return ""
        } catch {
            return ""
        }
    }

    guard !payload.isEmpty else { return nil }

    // ---- Validación segura de URL ----
    let trimmed = payload.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty, trimmed.count <= maxLength else { return nil }
    guard !containsControlCharacters(trimmed) else { return nil }
    guard var comps = URLComponents(string: trimmed) else { return nil }
    guard let scheme = comps.scheme?.lowercased(), !scheme.isEmpty else { return nil }

    if blockedSchemes.contains(scheme) { return nil }
    if scheme == "http", !allowHTTP { return nil }

    if scheme == "http" || scheme == "https" {
        guard let host = comps.host, !host.isEmpty else { return nil }
        if !allowLocalNetworkHosts, isLocalOrPrivateIPv4(host) { return nil }
    }
    if comps.user != nil || comps.password != nil { return nil }

    return comps.url
}
