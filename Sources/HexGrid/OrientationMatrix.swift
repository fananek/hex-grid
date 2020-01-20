internal struct OrientationMatrix {
    let f00, f10, f01, f11: Double
    let b00, b10, b01, b11: Double
    
    // Pointy on top hexagons starts at 30° and flat on top starts at 0°
    let startAngle: Double

    init (orientation: Orientation) {
        switch orientation {
        case Orientation.pointyOnTop:
            self.f00 = (3.0).squareRoot()
            self.f10 = (3.0).squareRoot()/2
            self.f01 = 0.0
            self.f11 = 3.0/2.0
            self.b00 = (3.0).squareRoot() / 3.0
            self.b10 = -1.0
            self.b01 = 0.0
            self.b11 = 2.0/3.0
            self.startAngle = 0.5
        case Orientation.flatOnTop:
            self.f00 = 3.0 / 2.0
            self.f10 = 0.0
            self.f01 = (3.0).squareRoot() / 2.0
            self.f11 = (3.0).squareRoot()
            self.b00 = 2.0 / 3.0
            self.b10 = 0.0
            self.b01 = -1.0/3.0
            self.b11 = (3.0).squareRoot() / 3.0
            self.startAngle = 0.0
        }
    }
}
