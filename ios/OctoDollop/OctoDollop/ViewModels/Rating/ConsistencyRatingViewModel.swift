//
//  ConsistencyRatingViewModel.swift
//  OctoDollop
//
//  Created by alber848 on 26/06/2022.
//

import Foundation



class ConsistencyRatingViewModel {
    
    // MARK: - Datasource properties
    
    
    /// The consistency rating
    public let consistency: Int
    
    
    // MARK: - Inits
    
    
    /// Class init
    ///
    /// - Parameter ratings: the ratings whose consistency should be computed
    init(ratings: [Rating]) {
        guard ratings.count > 1 else {
            consistency = 0
            return
        }
        
        // Extracting metrics
        var metrics: [[MetricType:Metric]] = []
        for rating in ratings {
            var metricsDic: [MetricType:Metric] = [:]
            for metric in rating.metrics.flatMap({ $0.metrics }) {
                metricsDic[metric.type] = metric
            }
            metrics.append(metricsDic)
        }
        // Evaluating shared metrics
        var commonMetricTypes = Set(metrics[0].keys)
        for metric in metrics {
            let metricTypes = Set(metric.keys)
            commonMetricTypes = commonMetricTypes.intersection(metricTypes)
        }
        // Grouping metrics by type
        var groupedMetrics: [MetricType:[Metric]] = [:]
        for metricDic in metrics {
            for (metricType, metric) in metricDic {
                guard commonMetricTypes.contains(metricType) else { continue }
                if let groupedMetricsType = groupedMetrics[metricType] {
                    groupedMetrics[metricType] = groupedMetricsType + [metric]
                } else {
                    groupedMetrics[metricType] = [metric]
                }
            }
        }
        // Grouping means by metric type
        var metricsMean: [MetricType:Double] = [:]
        for (metricType, metrics) in groupedMetrics {
            let mean = Double(metrics.map({ $0.score }).reduce(0, +)) / Double(metrics.count)
            metricsMean[metricType] = mean
        }
        // Grouping max values by metric type
        var metricsMaxima: [MetricType:Double] = [:]
        for (metricType, metrics) in groupedMetrics {
            metricsMaxima[metricType] = Double(metrics.map({ $0.score }).max() ?? 0)
        }
        // Computing inconsistency
        var evaluatedMetrics: Double = 0
        var relativeInconsistencySum: Double = 0
        for (metricType, metrics) in groupedMetrics {
            guard let maximum = metricsMaxima[metricType], let mean = metricsMean[metricType] else { continue }
            evaluatedMetrics += 1
            var squareDiffSum: Double = 0
            for metric in metrics {
                squareDiffSum += pow(Double(metric.score) - mean, 2)
            }
            let screensCount = Double(metrics.count)
            let metricsSqrt = sqrt(1/(screensCount - 1)*squareDiffSum)
            relativeInconsistencySum += (1/maximum)*metricsSqrt
        }
        
        let consistencyScore = 1 - (1/evaluatedMetrics)*relativeInconsistencySum
        consistency = Int(100 * consistencyScore)
    }
    
}
