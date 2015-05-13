import UIKit


let count = 400
for i in 0...count {
    i
}


for i in 0...count {
    // Linear
    i
    
    // Square
    i * i
    
    // Cubic
    i * i * i
    
    let percent = Double(i) / Double(count)
    
    // Ease in-out
    let j = (percent < 0.5) ? 0.5 * pow(percent * 2, 3) : 0.5 * (2.0 - pow((1.0 - percent) * 2, 4))
    
    // Damped sinusoid
    let time = percent * 3.0
    let k = 1.0 - cos(Double(M_PI) * 8.0 * percent) * exp(-1.0 * time)

}
