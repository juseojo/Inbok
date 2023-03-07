import UIKit
import SwiftUI

class TabBar_ViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        
        setupVCs()
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: help_ViewController(), title: NSLocalizedString("help", comment: ""), image: UIImage(systemName: "doc.text")!),
                createNavController(for: talk_ViewController(), title: NSLocalizedString("talk", comment: ""), image: UIImage(systemName: "message.fill")!),
            ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage)
        -> UIViewController {
            
            let navController = UINavigationController(rootViewController: rootViewController)
            
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            
            return navController
    }
}


//for free view
 struct PreView_Tab: PreviewProvider {
 static var previews: some View {
 TabBar_ViewController().toPreview()
 }
 }
 
 
 #if DEBUG
 extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
 let TabBar_ViewController: UIViewController
 
 func makeUIViewController(context: Context) -> UIViewController {
 return TabBar_ViewController
 }
 
 func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
 }
 }
 
 func toPreview_Tab() -> some View {
 Preview(TabBar_ViewController: self)
 }
 }
 #endif
 //end preview
