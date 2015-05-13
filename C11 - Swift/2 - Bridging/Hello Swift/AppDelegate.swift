/*

Erica Sadun, http://ericasadun.com

*/

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        let myTest = TestClass()
        myTest.test()
    }
}

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = self.window {
            let vc = ViewController(nibName: nil, bundle: nil)
            let nav = UINavigationController(rootViewController: vc);
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
        return true
    }
}
