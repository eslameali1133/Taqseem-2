import UIKit
import AVFoundation

class VideoLaunchVC: UIViewController {
    
    func setupAVPlayer() {
        
        let videoURL = Bundle.main.url(forResource: "WhatsApp Video 2019-05-06 at 15.58.05", withExtension: "mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayer.play() // Play video
        
        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
            
            if time == avAssets.duration {
               
                self?.Starapp()
                
            }
        }
    }
    //------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //------------------------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()  // Call method to setup AVPlayer & AVPlayerLayer to play video
    }
    
    
    func Starapp(){
        if  SharedData.SharedInstans.GetIsLogin() == false
        {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.present(vc, animated: true, completion: nil)
        }
        else
        {
            print(AppCommon.sharedInstance.getJSON("Profiledata")["type"].stringValue)
            if  AppCommon.sharedInstance.getJSON("Profiledata")["type"].stringValue == "ground_owner" {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                // let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                let storyboard = UIStoryboard.init(name: "Owner", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                
            }
            else{
                let delegate = UIApplication.shared.delegate as! AppDelegate
                //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
                
                delegate.window?.rootViewController =
                    storyboard.instantiateInitialViewController()
            }
        }
        
    }
}
