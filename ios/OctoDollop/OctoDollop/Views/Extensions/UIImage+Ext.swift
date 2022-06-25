//
//  UIImage+Ext.swift
//  OctoDollop
//
//  Created by alber848 on 14/12/2021.
//

import UIKit
import CoreImage


extension UIImage {
    
    /// Initializes UIImage with SF symbols icon
    ///
    /// - Parameters:
    ///   - systemName: the icon system name
    ///   - size: the desired icon size
    ///   - weight: the desired icon weight
    convenience init?(
        systemName: String,
        size: CGFloat,
        weight: SymbolWeight = .regular
    ) {
        self.init(
            systemName: systemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        )
    }
    
    /// - Returns: the average color of the image
    func areaAverage() -> UIColor {
        guard let cgImage = cgImage else { return .clear }
        var bitmap: [UInt8] = Array(repeating: 0, count: 4)
        
        // Get average color.
        let context = CIContext()
        let inputImage = ciImage ?? CIImage(cgImage: cgImage)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
}
