import UIKit

class TabBar_ViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        let help_VC = help_ViewController()
        let talk_VC = talk_ViewController()
        
        //각 tab bar의 viewcontroller 타이틀 설정
        
        help_VC.title = "help"
        talk_VC.title = "talk"
        
        help_VC.tabBarItem.image = UIImage.init(systemName: "house")
        talk_VC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
        
        help_VC.navigationItem.largeTitleDisplayMode = .always
        talk_VC.navigationItem.largeTitleDisplayMode = .always
        
        // navigationController의 root view 설정
        let navi_help = UINavigationController(rootViewController: help_VC)
        let navi_talk = UINavigationController(rootViewController: talk_VC)
        
    
        navi_help.navigationBar.prefersLargeTitles = true
        navi_talk.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navi_help, navi_talk], animated: false)
    }
}
