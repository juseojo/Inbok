import UIKit
import SwiftUI



class TabBar_ViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = UIColor(named: "BACKGROUND")
        UITabBar.appearance().tintColor = UIColor(named: "REVERSE_SYS")
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
        setupVCs()
        let line_view = UIView(frame: CGRect(x: 0, y: 0, width:self.tabBar.frame.size.width, height: 0.5))
        line_view.backgroundColor = UIColor.gray
        self.tabBar.addSubview(line_view)
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: help_ViewController(), image: UIImage(systemName: "heart")!, selected_image: UIImage(systemName: "heart.fill")!),
                createNavController(for: talk_ViewController(), image: UIImage(systemName: "message")!, selected_image: UIImage(systemName: "message.fill")!),
            ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, image: UIImage, selected_image: UIImage)
        -> UIViewController {
            
            let navController = UINavigationController(rootViewController: rootViewController)
            
            navController.tabBarItem.image = image
            navController.tabBarItem.selectedImage = selected_image
            
            return navController
    }
}

//for free view
 struct PreView_Tab: PreviewProvider {
 static var previews: some View {
 TabBar_ViewController().toPreview_Tab()
 }
 }
 
 
 #if DEBUG
 extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
 let TabBar_ViewController: UIViewController
 
 func makeUIViewController(context: Context) -> UIViewController{
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
