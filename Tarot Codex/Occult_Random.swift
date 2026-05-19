//
//  Occult_Random.swift
//  Tarot Codex
//
//  Created by William Parsons-Douglas on 19/05/2026.
//

import Foundation

struct MysticalGenerator {
    
    // Generates a "Daily Tarot Card" index (1 to 78) that stays the same for the entire day.
    
    static func generateDailyCardNumber() -> Int {
        let now = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: now)
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        let weekday = calendar.component(.weekday, from: now)
        
        let moonFactor = getMoonPhaseFactor(for: now) //Moon phase calculation
        let zodiacFactor = getZodiacFactor(month: month, day: day)
        
        // Deterministic seed for the day
        let seed = (year * 10000) + (month * 1000) + (day * 100) + (weekday * 10) + moonFactor + zodiacFactor
        
        // We use a simple hash-like calculation to spread the numbers
        let hashSeed = (seed * 1103515245 + 12345) & 0x7fffffff
        return (hashSeed % 78) + 1
    }

    /*Generates a "Tarot Card Reading" card index (1 to 78) that is mystical but changes
    every time it is called, influenced by the current second and hour.*/
    
    static func generateReadingCardNumber() -> Int {
        let now = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        let second = calendar.component(.second, from: now)
        
        let dailySeed = generateDailyCardNumber()
        
        // Combine the daily stability with high-frequency "momentary" energy
        let momentarySeed = (dailySeed * 7) + (hour * 13) + (minute * 17) + (second * 23)
        
        // Add actual system entropy to keep it unpredictable
        let entropy = Int.random(in: 1...1000)
        let finalSeed = momentarySeed + entropy
        
        return (finalSeed % 78) + 1
    }
    
    //Returns 0-29 representing the day in the lunar cycle
    private static func getMoonPhaseFactor(for date: Date) -> Int {
        let knownNewMoon = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 6, hour: 18, minute: 14).date!
        let secondsSinceNewMoon = date.timeIntervalSince(knownNewMoon)
        let daysSinceNewMoon = secondsSinceNewMoon / 86400
        let lunarCycle = 29.530588853
        let currentLunarDay = daysSinceNewMoon.truncatingRemainder(dividingBy: lunarCycle)
        return Int(currentLunarDay)
    }
    
    //Returns 1-12 representing the current Zodiac sign
    private static func getZodiacFactor(month: Int, day: Int) -> Int {
        switch (month, day) {
        case (3, 21...31), (4, 1...19): return 1  // Aries
        case (4, 20...30), (5, 1...20): return 2  // Taurus
        case (5, 21...31), (6, 1...20): return 3  // Gemini
        case (6, 21...30), (7, 1...22): return 4  // Cancer
        case (7, 23...31), (8, 1...22): return 5  // Leo
        case (8, 23...31), (9, 1...22): return 6  // Virgo
        case (9, 23...30), (10, 1...22): return 7 // Libra
        case (10, 23...31), (11, 1...21): return 8 // Scorpio
        case (11, 22...30), (12, 1...21): return 9 // Sagittarius
        case (12, 22...31), (1, 1...19): return 10 // Capricorn
        case (1, 20...31), (2, 1...18): return 11  // Aquarius
        case (2, 19...29), (3, 1...20): return 12  // Pisces
        default: return 1
        }
    }
}
