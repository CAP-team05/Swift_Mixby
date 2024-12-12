//
//  LocationManager.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0

    var onLocationUpdate: ((Double, Double) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 위치 업데이트 저장
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude

        // 위치 업데이트 클로저 호출
        onLocationUpdate?(latitude, longitude)

        // 위치 업데이트 중지
        locationManager.stopUpdatingLocation()
        print("위치 업데이트 완료: \(latitude), \(longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
    }
}

