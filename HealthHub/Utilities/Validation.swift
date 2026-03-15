import Foundation

/// Validation errors for data models
enum ValidationError: Error, LocalizedError {
    case invalidValue(String)
    case invalidDateRange(String)
    case missingRequired(String)

    var errorDescription: String? {
        switch self {
        case .invalidValue(let detail): return "Virheellinen arvo: \(detail)"
        case .invalidDateRange(let detail): return "Virheellinen aikaväli: \(detail)"
        case .missingRequired(let detail): return "Puuttuva tieto: \(detail)"
        }
    }
}

/// Protocol for validatable data models
protocol Validatable {
    func validate() throws
}

// MARK: - Model Validation Extensions

extension HealthMetric: Validatable {
    func validate() throws {
        guard value >= 0 else {
            throw ValidationError.invalidValue("Mittarin arvo ei voi olla negatiivinen (\(type.rawValue): \(value))")
        }
        guard recordedAt <= Date() else {
            throw ValidationError.invalidDateRange("Kirjausaika ei voi olla tulevaisuudessa")
        }
    }
}

extension MigraineEvent: Validatable {
    func validate() throws {
        if let endTime {
            guard endTime >= startTime else {
                throw ValidationError.invalidDateRange("Päättymisaika ei voi olla ennen alkamisaikaa")
            }
        }
        guard startTime <= Date().addingTimeInterval(60) else {
            throw ValidationError.invalidDateRange("Alkamisaika ei voi olla tulevaisuudessa")
        }
    }
}

extension MealEntry: Validatable {
    func validate() throws {
        guard mealTime <= Date().addingTimeInterval(60) else {
            throw ValidationError.invalidDateRange("Aterian aika ei voi olla tulevaisuudessa")
        }
    }
}

extension Baseline: Validatable {
    func validate() throws {
        guard medianValue >= 0 else {
            throw ValidationError.invalidValue("Perusviivan mediaani ei voi olla negatiivinen")
        }
        guard sampleCount > 0 else {
            throw ValidationError.invalidValue("Näytteiden määrä tulee olla vähintään 1")
        }
    }
}
