//
//  GameScene.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import SpriteKit
import iAd
import AVFoundation
import Social
import GameKit

extension UIView{
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class GameScene: SKScene, ADBannerViewDelegate {
    //View controller
    var gameViewController: GameViewController = GameViewController()
    
    //SKSpriteNodes
    var panda: Panda = Panda(character: "Zanda")
    var starMain: Star = Star()
    var stars: [Star] = []
    var fallingObjectMain: FallingObject = FallingObject()
    var fallingObjects: [FallingObject] = []
    var characterArray: [String] = []
    var groundSprite:SKSpriteNode = SKSpriteNode()
    var groundSprites: [SKSpriteNode] = []
    var ground = SKNode()
    
    //Force Field
    var forceField: ForceField = ForceField()
    var shieldForceField: Bool = false
    
    var currentFallingObjectCounter: Int = 0
    
    //Score variables
    var score: Int = 0
    var starScore: Int = 0
    var scoreLabel: SKLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var scoreBackground: SKSpriteNode = SKSpriteNode()
    var gamePausedLabel: SKLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var gamePausedBackground: SKSpriteNode = SKSpriteNode()
    var gameOverScoreLabel: SKLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var gameOverBestScoreLabel: SKLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    var gameOverImageView: SKSpriteNode = SKSpriteNode()
    var holdToMoveImageView: SKSpriteNode = SKSpriteNode()
    var loadingScreenUIView: SKSpriteNode = SKSpriteNode()
    
    //Buttons
    var playButton: UIButton = UIButton()
    var exitButton: UIButton = UIButton()
    var shareButton: UIButton = UIButton()
    var pauseButton: UIButton = UIButton()
    var soundButton: UIButton = UIButton()
    
    var fastPowerUpTimer: NSTimer = NSTimer()
    var shrinkPowerUpTimer: NSTimer = NSTimer()
    var bananaPeelThrowTimer: NSTimer = NSTimer()
    var loadingScreenTimer: NSTimer = NSTimer()
    
    //Panda speed
    var pandaSpeed: CGFloat = 2
    var pandaMovementTimer: CGFloat = 7
    
    //Falling object speed
    var fallingObjectMinSpeed: CGFloat = 4
    var fallingObjectMaxSpeed: CGFloat = 7
    var fallingObjectCurrSpeed: CGFloat = 4
    var fallingObjectXPosition1: CGFloat = 0
    var fallingObjectXPosition2: CGFloat = 0
    var fallingObjectXPosition3: CGFloat = 0
    var fallingObjectXPosition4: CGFloat = 0
    var fallingObjectPrimaryCounter: Int = 0
    var fallingObjectSecondaryCounter: Int = 0
    var fallingObjectTimer: NSTimer = NSTimer()
    
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    //Levels
    var levelNumRandomOptions: UInt32 = 1;
    var gameOver = false
    var gamePaused = false
    var startPlaying = false
    var isPrimaryForceField = true
    
    //Sound
    var mute = false
    
    //Selected character
    var selectedChar: Int = 0
    var selectedCharacterName: String = "ZandaRunning"
    
    //Selected mode
    var selectedMode:String = "Castle"
    
    //iAd banner
    var iAdBannerView:ADBannerView = ADBannerView()
    
    //Audio player
    var pickupStarAudioPlayer:AVAudioPlayer = AVAudioPlayer()
    var pickupStarSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("PickupStar", ofType: "wav")!)
    var forceFieldAudioPlayer:AVAudioPlayer = AVAudioPlayer()
    var forceFieldSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ForceField", ofType: "wav")!)
    
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    override func didMoveToView(view: SKView) {
        //Load selected character
        selectedChar = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtSelectedChar")
        
        //Load selected mode
        selectedMode = NSUserDefaults.standardUserDefaults().stringForKey("ZPExtSelectedMode")!
        
        //Play button
        let playGameImage = UIImage(named: "PlayButton") as UIImage?
        playButton.setImage(playGameImage, forState: .Normal)
        playButton.frame = CGRectMake((bounds.size.width / 2) - 30, bounds.size.height / 2 + 25, 60, 40)
        playButton.addTarget(self, action: "startButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        playButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        self.view?.addSubview(playButton)
        playButton.hidden = true
        
        //Share button
        let shareGameImage = UIImage(named: "ShareButton") as UIImage?
        shareButton.setImage(shareGameImage, forState: .Normal)
        shareButton.frame = CGRectMake((bounds.size.width / 2) - 120, (bounds.size.height / 2) + 85, 60, 40)
        shareButton.addTarget(self, action: "shareButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        shareButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        self.view?.addSubview(shareButton)
        shareButton.hidden = true
        
        //Exit button
        let exitGameImage = UIImage(named: "ExitButton") as UIImage?
        exitButton.setImage(exitGameImage, forState: .Normal)
        exitButton.frame = CGRectMake((bounds.size.width / 2) + 60, (bounds.size.height / 2) + 85, 60, 40)
        exitButton.addTarget(self, action: "exitButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        exitButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        self.view?.addSubview(exitButton)
        exitButton.hidden = true
        
        //Pause button
        let pauseImage = UIImage(named: "PauseButton") as UIImage?
        pauseButton.frame = CGRectMake((bounds.size.width - 75), 100, 40, 40)
        pauseButton.setImage(pauseImage, forState: .Normal)
        pauseButton.addTarget(self, action: "pauseButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(pauseButton)
        
        //Sound button
        let soundImage = UIImage(named: "SoundButton") as UIImage?
        soundButton.frame = CGRectMake(35, 100, 40, 40)
        soundButton.setImage(soundImage, forState: .Normal)
        soundButton.addTarget(self, action: "soundButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(soundButton)
        
        let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPFastPowerUps")
        
        var fastImage: String = "FastPowerUpMaskButton"
        if(fastPowerUps > 0){
            fastImage = "FastPowerUpButton"
        }
        
        let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtShrinkPowerUps")
        
        var shrinkImage: String = "ShrinkPowerUpMaskButton"
        if(shrinkPowerUps > 0){
            shrinkImage = "ShrinkPowerUpButton"
        }
        
        let bananaPeelPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtBananaPeelPowerUps")
        
        var bananaPeelImage: String = "BananaPeelThrowMaskButton"
        if(bananaPeelPowerUps > 0){
            bananaPeelImage = "BananaPeelThrowButton"
        }
        
        //Load audio player
        pickupStarAudioPlayer = AVAudioPlayer(contentsOfURL: pickupStarSound, error: nil)
        pickupStarAudioPlayer.prepareToPlay()
        forceFieldAudioPlayer = AVAudioPlayer(contentsOfURL: forceFieldSound, error: nil)
        forceFieldAudioPlayer.prepareToPlay()
        
        //Load game over image
        gameOverScoreLabel.text = "0"
        gameOverScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        gameOverBestScoreLabel.text = "0"
        gameOverBestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        let gameOverImage = UIImage(named: "GameOver") as UIImage?
        var gameOverImageTexture = SKTexture(image:gameOverImage!)
        gameOverImageView = SKSpriteNode(texture: gameOverImageTexture,size: CGSizeMake(250, 150))
        gameOverImageView.position.x = (bounds.width / 2)
        gameOverImageView.position.y = (bounds.size.height/2) + (gameOverImageView.frame.height/2) + 10
        gameOverImageView.zPosition = 10
        gameOverImageView.addChild(gameOverBestScoreLabel)
        gameOverImageView.addChild(gameOverScoreLabel)
        gameOverScoreLabel.position = CGPointMake(gameOverImageView.frame.width/2 - 10, -gameOverScoreLabel.frame.size.height/2)
        gameOverBestScoreLabel.position = CGPointMake(gameOverImageView.frame.width/2   - 10, -gameOverBestScoreLabel.frame.size.height/2 - 50)
        gameOverImageView.hidden = true
        
        var sectionWidth: CGFloat = bounds.width / 4
        fallingObjectXPosition1 = sectionWidth / 2
        fallingObjectXPosition2 = (sectionWidth * 2) - (sectionWidth/2)
        fallingObjectXPosition3 = (sectionWidth * 3) - (sectionWidth/2)
        fallingObjectXPosition4 = (sectionWidth * 4) - (sectionWidth/2)
        
        loadAds()
        loadCharacter()
        startGame()
    }
    
    func loadCharacter(){
        characterArray = []
        
        characterArray.append("Zanda")
        characterArray.append("Pharaoh")
        characterArray.append("Panda")
        characterArray.append("Mummy")
        characterArray.append("Ghost")
        characterArray.append("Nappy")
        characterArray.append("Snowman")
        characterArray.append("Alien")
        characterArray.append("Trex")
        characterArray.append("General")
        characterArray.append("Dragon")
        
        selectedCharacterName = characterArray[selectedChar]
    }
    
    func startGame(){
        self.removeAllActions()
        self.removeAllChildren()
        
        /* Setup your scene here */
        bounds = UIScreen.mainScreen().bounds
        //Score variables
        score = 0
        starScore = 0
        currentFallingObjectCounter = 0
        scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        gamePausedLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        gameOverScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        gameOverBestScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
        gameOverImageView = SKSpriteNode()

        stars = []
        fallingObjects = []
        groundSprites = []
        
        //iAds hide iAd banner
        //iAdBannerView.hidden = true
        
        //Levels
        levelNumRandomOptions = 1;
        gameOver = false
        gamePaused = false
        startPlaying = false
        
        //Score label
        scoreLabel.text = "0"
        
        //Score background
        let scoreUIImage = UIImage(named: "ScoreBackground") as UIImage?
        var scoreTexture = SKTexture(image: scoreUIImage!)
        scoreBackground = SKSpriteNode(texture: scoreTexture, size: CGSizeMake(scoreLabel.frame.size.width + 30, scoreLabel.frame.size.height + 5))
        scoreBackground.position.y = bounds.height - 150
        scoreBackground.position.x = bounds.size.width / 2
        scoreBackground.zPosition = 10
        scoreBackground.addChild(scoreLabel)
        scoreBackground.hidden = false
        scoreLabel.position = CGPointMake(0, -scoreLabel.frame.size.height/2)
        
        //Load game over image
        gameOverScoreLabel.text = "0"
        gameOverScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        gameOverBestScoreLabel.text = "0"
        gameOverBestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        let gameOverImage = UIImage(named: "GameOver") as UIImage?
        var gameOverImageTexture = SKTexture(image:gameOverImage!)
        gameOverImageView = SKSpriteNode(texture: gameOverImageTexture,size: CGSizeMake(250, 150))
        gameOverImageView.position.x = (bounds.width / 2)
        gameOverImageView.position.y = (bounds.size.height/2) + (gameOverImageView.frame.height/2) + 10
        gameOverImageView.zPosition = 10
        gameOverScoreLabel.position = CGPointMake(gameOverImageView.frame.width/2 - 10, -gameOverScoreLabel.frame.size.height/2)
        gameOverBestScoreLabel.position = CGPointMake(gameOverImageView.frame.width/2   - 10, -gameOverBestScoreLabel.frame.size.height/2 - 50)
        gameOverImageView.addChild(gameOverBestScoreLabel)
        gameOverImageView.addChild(gameOverScoreLabel)
        gameOverImageView.hidden = true
        
        //Hold to move size
        let originalWidth:CGFloat = 750
        let originalHeight:CGFloat = 300
        var newWidth:CGFloat = (bounds.width - 20)
        var newHeight:CGFloat = (newWidth / originalWidth) * originalHeight
        
        //Hold to move image
        let holdToMoveImage = UIImage(named: "TapToSwitch") as UIImage?
        var holdToMoveImageTexture = SKTexture(image:holdToMoveImage!)
        holdToMoveImageView = SKSpriteNode(texture: holdToMoveImageTexture,size: CGSizeMake(newWidth, newHeight))
        holdToMoveImageView.position.x = (bounds.width / 2)
        holdToMoveImageView.position.y = (bounds.size.height/2) + (holdToMoveImageView.frame.height/2) + 10
        holdToMoveImageView.zPosition = 10
        holdToMoveImageView.hidden = false
        
        //Game over label
        gamePausedLabel.text = "Game Paused"
        let gamePausedUIImage = UIImage(named: "ScoreBackground") as UIImage?
        var gamePausedTexture = SKTexture(image:gamePausedUIImage!)
        //var gamePausedTexture = SKTexture(imageNamed:"ScoreBackground")
        gamePausedBackground = SKSpriteNode(texture: gamePausedTexture, size: CGSizeMake(gamePausedLabel.frame.size.width + 30, gamePausedLabel.frame.size.height + 15))
        gamePausedBackground.position.x = bounds.size.width / 2
        gamePausedBackground.position.y = bounds.size.height - 250
        gamePausedBackground.zPosition = 9
        gamePausedBackground.addChild(gamePausedLabel)
        gamePausedLabel.position = CGPointMake(0, -gamePausedLabel.frame.size.height/2)
        gamePausedBackground.hidden = true
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -1.0)
        
        //Star
        starMain = Star()
        
        var backgroundName:String = "BackgroundStadium"
        
        if(selectedMode == "Stadium"){
            backgroundName = "BackgroundStadium"
        }else if(selectedMode == "Jurassic"){
            backgroundName = "BackgroundJurassic"
        }else if(selectedMode == "Pyramid"){
            backgroundName = "BackgroundPyramid"
        }else if(selectedMode == "IceAge"){
            backgroundName = "BackgroundIceAge"
        }else if(selectedMode == "Castle"){
            backgroundName = "BackgroundCastle"
        }
        
        //Background
        
        let backgroundUIImage = UIImage(named: backgroundName) as UIImage?
        var backgroundTexture = SKTexture(image:backgroundUIImage!)
        //var backgroundTexture = SKTexture(imageNamed:"Background")
        var background = SKSpriteNode(texture: backgroundTexture)
        let backgroundOriginalWidth: CGFloat = 600
        let backgroundOriginalHeight: CGFloat = 1200
        var backgroundNewWidth:CGFloat = bounds.width
        var backgroundNewHeight:CGFloat = (backgroundNewWidth / backgroundOriginalWidth) * backgroundOriginalHeight
        background.size.width = backgroundNewWidth
        background.size.height = backgroundNewHeight
        background.position = CGPointMake(bounds.width / 2, bounds.size.height / 2)
        background.zPosition = -5
        
        var groundName:String = "GroundIceAge"
        
        if(selectedMode == "Stadium"){
            groundName = "GroundStadium"
        }else if(selectedMode == "Jurassic"){
            groundName = "GroundJurassic"
        }else if(selectedMode == "Pyramid"){
            groundName = "GroundPyramid"
        }else if(selectedMode == "IceAge"){
            groundName = "GroundIceAge"
        }else if(selectedMode == "Castle"){
            groundName = "GroundCastle"
        }
        
        //Ground
        let groundUIImage = UIImage(named: groundName) as UIImage?
        var groundTexture = SKTexture(image:groundUIImage!)
        groundSprite = SKSpriteNode(texture: groundTexture)
        let groundImageOriginalWidth: CGFloat = 700
        let groundImageOriginalHeight: CGFloat = 150
        var groundNewWidth:CGFloat = bounds.width
        var groundNewHeight:CGFloat = (groundNewWidth / groundImageOriginalWidth) * groundImageOriginalHeight
        groundSprite.size.width = groundNewWidth
        groundSprite.size.height = groundNewHeight
        groundSprite.position = CGPointMake(bounds.width/2, groundSprite.size.height/2)
        groundSprite.zPosition = 11
        
        let forceFieldOriginalWidth: CGFloat = 700
        let forceFieldOriginalHeight: CGFloat = 300
        var forceFieldNewWidth:CGFloat = bounds.width
        var forceFieldNewHeight:CGFloat = (forceFieldNewWidth / forceFieldOriginalWidth) * forceFieldOriginalHeight
        forceField = ForceField(selectedMode: selectedMode, fieldWidth: forceFieldNewWidth, fieldHeight: forceFieldNewHeight, isShield: shieldForceField)
        forceField.position = CGPointMake(bounds.width/2, groundSprite.size.height)
        forceField.zPosition = 10
     
        ground.position = CGPointMake(groundSprite.size.width/2, groundSprite.size.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(groundNewWidth*4, groundNewHeight))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        
        /*
        var wallLeft = SKNode()
        wallLeft.position = CGPointMake(-20, 0)
        wallLeft.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, bounds.height + fallingObjectMain.size.height))
        wallLeft.physicsBody?.dynamic = false
        
        var wallRight = SKNode()
        wallRight.position = CGPointMake(bounds.width, 0)
        wallRight.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, bounds.height + fallingObjectMain.size.height))
        wallRight.physicsBody?.dynamic = false*/
        
        //Panda
        panda = Panda(character: selectedCharacterName)
        var pandaXPos = floor(bounds.size.width * 0.47)
        panda.position = CGPoint(x: pandaXPos, y: groundSprite.frame.origin.y + groundSprite.frame.height + panda.panda.frame.height/2)
        panda.zPosition = 5
        
        //Panda speed setup
        var boundsDistance:CGFloat = bounds.size.width - panda.frame.width
        var newSpeed: CGFloat = boundsDistance / (pandaMovementTimer / 0.035)
        pandaSpeed = newSpeed
        
        //Set falling object speed
        fallingObjectCurrSpeed = fallingObjectMinSpeed
        
        isPrimaryForceField = true
        
        //Add default stars
        let starXPos1 = fallingObjectXPosition1
        let starXPos2 = fallingObjectXPosition2
        let starXPos3 = fallingObjectXPosition3
        let starXPos4 = fallingObjectXPosition4
        
        //Star 1
        let star1 = starMain.copy() as Star
        let starYPos1: CGFloat = groundSprite.size.height + (star1.size.height / 2) + 10
        star1.position = CGPoint(x: starXPos1, y: starYPos1)
        star1.zPosition = 5
        star1.hidden = true
        star1.hasPassed = true
        stars.append(star1)
        self.addChild(star1)
        
        //Star 2
        let star2 = starMain.copy() as Star
        let starYPos2: CGFloat = groundSprite.size.height + (star2.size.height / 2) + 10
        star2.position = CGPoint(x: starXPos2, y: starYPos2)
        star2.zPosition = 5
        star2.hidden = true
        star2.hasPassed = true
        stars.append(star2)
        self.addChild(star2)
        
        //Star 3
        let star3 = starMain.copy() as Star
        let starYPos3: CGFloat = groundSprite.size.height + (star3.size.height / 2) + 10
        star3.position = CGPoint(x: starXPos3, y: starYPos3)
        star3.zPosition = 5
        star3.hidden = true
        star3.hasPassed = true
        stars.append(star3)
        self.addChild(star3)
        
        //Star 4
        let star4 = starMain.copy() as Star
        let starYPos4: CGFloat = groundSprite.size.height + (star4.size.height / 2) + 10
        star4.position = CGPoint(x: starXPos4, y: starYPos4)
        star4.zPosition = 5
        star4.hidden = true
        star4.hasPassed = true
        stars.append(star4)
        self.addChild(star4)
        
        /*let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPFastPowerUps")
        
        
        if(fastPowerUps > 0){
            let fastPowerUpImage = UIImage(named: "FastPowerUpButton") as UIImage?
            fastPowerUpButton.setImage(fastPowerUpImage, forState: .Normal)
        }
        
        let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPShrinkPowerUps")
        
        if(shrinkPowerUps > 0){
            let shrinkPowerUpImage = UIImage(named: "ShrinkPowerUpButton") as UIImage?
            shrinkPowerUpButton.setImage(shrinkPowerUpImage, forState: .Normal)
        }
        
        let bananaPeelThrows = NSUserDefaults.standardUserDefaults().integerForKey("ZPBananaPeelPowerUps")
        
        if(bananaPeelThrows > 0){
            let bananaPeelThrowImage = UIImage(named: "BananaPeelThrowButton") as UIImage?
            bananaPeelThrowButton.setImage(bananaPeelThrowImage, forState: .Normal)
        }*/
        
        if(!self.appdelegate().iAdsUnlocked){
            iAdBannerView.hidden = false
        }
        
        self.addChild(groundSprite)
        self.addChild(ground)
        self.addChild(panda)
        self.addChild(background)
        //self.addChild(wallLeft)
        //self.addChild(wallRight)
        self.addChild(forceField)
        self.addChild(scoreBackground)
        self.addChild(gameOverImageView)
        self.addChild(holdToMoveImageView)
        self.addChild(gamePausedBackground)
    }
    
    func loadAds(){
        if(!self.appdelegate().iAdsUnlocked){
            /*iAdBannerView.delegate = self
            iAdBannerView = self.appdelegate().iAdBannerView
            iAdBannerView.center = CGPoint(x: iAdBannerView.center.x, y: bounds.height - iAdBannerView.frame.size.height / 2)
            view?.addSubview(iAdBannerView)*/
            
            
            iAdBannerView = ADBannerView()
            iAdBannerView.center = CGPoint(x: iAdBannerView.center.x, y: bounds.height - iAdBannerView.frame.size.height / 2)
            iAdBannerView.delegate = self
            view?.addSubview(iAdBannerView)
        }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.view?.addSubview(banner)
        self.view?.layoutIfNeeded()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Failed to retrieve ad")
        banner.removeFromSuperview()
        self.view?.layoutIfNeeded()
    }
    
    func startButtonAction(sender: UIButton!){
        loadingScreenUIView.hidden = true
        playButton.hidden = true
        shareButton.hidden = true
        exitButton.hidden = true
        gamePausedBackground.hidden = true
        gameOverImageView.hidden = true
        iAdBannerView.hidden = true
        loadingScreen()
    }
    
    func shareButtonAction(sender: UIButton!){
        //Alert dialog box for social sharing
        var alert = UIAlertController(title: "Social Media Share", message: "Share your high score with your friends!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Facebook", style: .Default, handler: {action in
            NSLog("facebook clicked")
            self.shareToFacebook()
        }))
        alert.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: {action in
            NSLog("Twitter clicked")
            self.shareToTwitter()
        }))
        /*alert.addAction(UIAlertAction(title: "Sina Weibo", style: .Default, handler: {action in
        NSLog("Sina Weibo clicked")
        self.shareToSinaWeibo()
        }))
        alert.addAction(UIAlertAction(title: "Tencent Weibo", style: .Default, handler: {action in
        NSLog("Tencent Weibo clicked")
        self.shareToTencentWeibo()
        }))*/
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: {action in
            NSLog("cancel clicked")
        }))
        self.gameViewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func exitButtonAction(sender: UIButton!){
        //Reset everything
        self.removeAllChildren()
        //crushers = []
        //stars = []
        //groundSprites = []
        
        self.gameViewController.exitViewController()
    }
    
    func soundButtonAction(sender: UIButton!){
        if(mute){
            let soundImage = UIImage(named: "SoundButton") as UIImage?
            soundButton.setImage(soundImage, forState: .Normal)
            mute = false
        }
        else{
            let noSoundImage = UIImage(named: "NoSoundButton") as UIImage?
            soundButton.setImage(noSoundImage, forState: .Normal)
            mute = true
        }
    }
    
    func pauseButtonAction(sender: UIButton!){
        if(!gameOver){
            if(gamePaused){
                let pauseImage = UIImage(named: "PauseButton") as UIImage?
                pauseButton.setImage(pauseImage, forState: .Normal)
                gamePaused = false
                gamePausedBackground.hidden = true
                //iAdBannerView.hidden = true
            }
            else{
                let playImage = UIImage(named: "PlaySmallButton") as UIImage?
                pauseButton.setImage(playImage, forState: .Normal)
                gamePaused = true
                gamePausedBackground.hidden = false
                //iAdBannerView.hidden = false
            }
        }
    }
    
    func spawnFallingObjects(numObjects: Int)
    {
        var isPrimary: Bool = true
        let randomNumber = Int(arc4random_uniform(2))
        if(randomNumber % 2 == 0){
            isPrimary = true
        }else{
            isPrimary = false
        }
        
        if(fallingObjectPrimaryCounter == 2 && isPrimary){
            isPrimary = false
            fallingObjectPrimaryCounter = 0
            fallingObjectSecondaryCounter = 1
        }else if(fallingObjectSecondaryCounter == 2 && !isPrimary){
            isPrimary = true
            fallingObjectPrimaryCounter = 1
            fallingObjectSecondaryCounter = 0
        }else{
            if(isPrimary){
                fallingObjectPrimaryCounter++
                fallingObjectSecondaryCounter = 0
            }else{
                fallingObjectPrimaryCounter = 0
                fallingObjectSecondaryCounter++
            }
        }
        
        var firstPositionTaken = false
        var secondPositionTaken = false
        var thirdPositionTaken = false
        var fourthPositionTaken = false
        
        for (var i = 0; i < numObjects; i++)
        {
            let fallingObject = FallingObject(selectedMode: selectedMode, isPrimary: isPrimary)
            var minXPos: CGFloat = 0
            var maxXPos: UInt32 = UInt32(bounds.width - fallingObject.size.width)
            let randomXPos = Int(arc4random_uniform(4)) + 1
            
            if(randomXPos == 1){
                if(!firstPositionTaken){
                    firstPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition1
                }else{
                    secondPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition2
                }
            }else if(randomXPos == 2){
                if(!secondPositionTaken){
                    secondPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition2
                }else{
                    thirdPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition3
                }
            }else if(randomXPos == 3){
                if(!thirdPositionTaken){
                    thirdPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition3
                }else{
                    fourthPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition4
                }
            }else if(randomXPos == 4){
                if(!fourthPositionTaken){
                    fourthPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition4
                }else{
                    firstPositionTaken = true
                    fallingObject.position.x = fallingObjectXPosition1
                }
            }
            
            var yy: CGFloat = bounds.size.height + fallingObject.size.height
            
            fallingObject.position.y = CGFloat(yy)
            fallingObject.zPosition = 4
            
            fallingObjects.append(fallingObject)
            self.addChild(fallingObject)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if(!startPlaying){
            holdToMoveImageView.hidden = true
            startPlaying = true
            panda.isPandaRunning = true
            self.spawnFallingObjects(1)
            
            fallingObjectTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("increaseFallingObjectSpeed"), userInfo: nil, repeats: true)
        }else{
            if(!gamePaused && !gameOver){
                if(isPrimaryForceField){
                    isPrimaryForceField = false
                    forceField.isForceFieldPrimary = false
                    forceField.changeForceFieldImage()
                }else{
                    isPrimaryForceField = true
                    forceField.isForceFieldPrimary = true
                    forceField.changeForceFieldImage()
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    @objc func increaseFallingObjectSpeed(){
        //Do something if required
        if(fallingObjectCurrSpeed < fallingObjectMaxSpeed){
            fallingObjectCurrSpeed = fallingObjectCurrSpeed + 0.5
            //NSLog("Current Speed: %@", fallingObjectCurrSpeed)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(!gameOver && !gamePaused){
            //Make panda shaking
            if(panda.isPandaShakingLeft)
            {
                panda.isPandaShakingLeft = false
            }
            else
            {
                panda.isPandaShakingLeft = true
            }
            
            //Move crushers horizontally and spawn crushers
            if(panda.isPandaRunning)
            {
                //Change panda moving texture
                panda.changeRunningImage()
                if(panda.isPandaRunningLeft){
                    if(panda.position.x - (panda.panda.size.width/2) - pandaSpeed > 0){
                        panda.position.x -= pandaSpeed
                    }else{
                        panda.position.x = (panda.panda.size.width/2)
                        panda.isPandaRunningLeft = false
                        panda.changeDirection()
                    }
                }else{
                    if(panda.position.x + (panda.panda.size.width/2) + pandaSpeed < bounds.width){
                        panda.position.x += pandaSpeed
                    }else{
                        panda.position.x = bounds.width - (panda.panda.size.width/2)
                        panda.isPandaRunningLeft = true
                        panda.changeDirection()
                    }
                }
            }
            
            var fallingObjectRemoveIndex = 0
            
            for(var i = 0; i < fallingObjects.count; i++){
                let fallingObject = fallingObjects[i]
                
                moveFallingObject(fallingObject)
                
                if(fallingObject.position.y < 0){
                    fallingObjectRemoveIndex = i
                }
                
                var fallingObjectFrame: CGRect = CGRectMake(fallingObject.position.x - (fallingObject.size.width / 2),  fallingObject.position.y - (fallingObject.size.height/2), fallingObject.size.width, fallingObject.size.height)
                var forceFieldFrame: CGRect = CGRectMake(0, forceField.position.y - (forceField.size.height/2), forceField.size.width, forceField.size.height)
                var pandaFrame: CGRect = CGRectMake(panda.position.x - (panda.size.width / 2), (groundSprite.size.height/2), panda.size.width, panda.size.height)
                
                if(!fallingObject.hasPassed){
                    if(CGRectIntersectsRect(forceFieldFrame, fallingObjectFrame)){
                        if(fallingObject.isFallingObjectPrimary && isPrimaryForceField){
                            score++
                            scoreLabel.text = NSString(format: "%i", score)
                        }else if(!fallingObject.isFallingObjectPrimary && !isPrimaryForceField){
                            score++
                            scoreLabel.text = NSString(format: "%i", score)
                        }else{
                            gameFinished()
                        }
                        
                        //Play sound if not mute
                        if(!mute){
                            forceFieldAudioPlayer.play()
                        }
                        
                        if(!gameOver){
                            fallingObject.hasPassed = true
                            fallingObject.hidden = true
                        }
                    }
                }
                
                if(i == fallingObjects.count - 1){
                    if(fallingObject.position.y < bounds.height - (fallingObject.size.height/2)){
                        //let randomFallingObjectNum = Int(arc4random_uniform(3))
                        let randomFallingObjectNum = 1
                        self.spawnFallingObjects(randomFallingObjectNum)
                        currentFallingObjectCounter++
                    }
                }
            }
            
            for (var i = 0; i < stars.count; i++)
            {
                let star = stars[i]
                
                if(!star.hasPassed){
                    var starLeftPosition = star.position.x - (star.size.width / 2) + 1
                    var starRightPosition = star.position.x + (star.size.width / 2) - 1
                    
                    if(starLeftPosition <= panda.position.x && starRightPosition >= panda.position.x)
                    {
                        starScore++
                        star.hasPassed = true
                        star.hidden = true
                        
                        //Play sound if not mute
                        if(!mute){
                            pickupStarAudioPlayer.play()
                        }
                    }
                }
            }
            
            //Add star for every 12 crushers
            if(currentFallingObjectCounter == 12){
                let randomXPos = Int(arc4random_uniform(4))
                let star = stars[randomXPos]
                
                star.hidden = false
                star.hasPassed = false
                //Update crusher counter
                currentFallingObjectCounter = 0
            }
            
            //Remove falling objects out of boundss
            if(fallingObjectRemoveIndex > 0){
                let range = Range(start: 0, end: fallingObjectRemoveIndex)
                fallingObjects.removeRange(range)
            }
        }
    }
    
    func moveFallingObject(fallingObject: FallingObject){
        fallingObject.position.y -= fallingObjectCurrSpeed
    }
    
    func gameFinished(){
        if(!self.appdelegate().iAdsUnlocked){            
            let currentTime = NSDate()
            var elapsedTime: Double = currentTime.timeIntervalSinceDate(appdelegate().lastAdDisplay)
            
            if(elapsedTime > appdelegate().interstitialAdInterval){
                //Display interstitial ad every 2-3 minutes. Configurable
                appdelegate().lastAdDisplay = NSDate()
                appdelegate().showChartboostAds()
            }else if(elapsedTime < 0){
                appdelegate().lastAdDisplay = NSDate()
            }
        }
        
        playButton.hidden = false
        shareButton.hidden = false
        exitButton.hidden = false
        gameOverImageView.hidden = false
        soundButton.hidden = true
        gamePausedBackground.hidden = true
        scoreBackground.hidden = true
        pauseButton.hidden = true
        gameOver = true
        fallingObjectTimer.invalidate()
        saveScore(score)
        panda.stop()
    }
    
    func loadingScreen(){
        //Loading screen
        let loadingScreenImage = UIImage(named: "LoadingScreen") as UIImage?
        var loadingScreenTexture = SKTexture(image:loadingScreenImage!)
        loadingScreenUIView = SKSpriteNode(texture: loadingScreenTexture)
        let loadingScreenOriginalWidth: CGFloat = 600
        let loadingScreenOriginalHeight: CGFloat = 1200
        var loadingScreenNewWidth:CGFloat = bounds.width
        var loadingScreenNewHeight:CGFloat = (loadingScreenNewWidth / loadingScreenOriginalWidth) * loadingScreenOriginalHeight
        loadingScreenUIView.size.width = loadingScreenNewWidth
        loadingScreenUIView.size.height = loadingScreenNewHeight
        loadingScreenUIView.position = CGPointMake(bounds.width / 2, bounds.size.height / 2)
        loadingScreenUIView.zPosition = 20
        loadingScreenUIView.hidden = false
        self.addChild(loadingScreenUIView)
        
        loadingScreenTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("loadingScreenFinish"), userInfo: nil, repeats: false)
    }
    
    @objc func loadingScreenFinish(){
        pauseButton.hidden = false
        soundButton.hidden = false
        
        if(!self.appdelegate().iAdsUnlocked){
            iAdBannerView.hidden = false
        }
        
        startGame()
    }
    
    func saveScore(newScore:Int){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var starsCollectedResult: Int = starsCollected + starScore
        
        NSUserDefaults.standardUserDefaults().setInteger(starsCollectedResult, forKey: "ZPExtStarsCollected")
        
        var highScoreName:String = "ZPExtHS" + selectedMode
        
        //High score
        let highScoreNumber = NSUserDefaults.standardUserDefaults().integerForKey(highScoreName)
        
        gameOverScoreLabel.text = NSString(format: "%i", newScore)
        gameOverScoreLabel.zPosition = 15
        
        if(newScore > highScoreNumber){
            gameOverBestScoreLabel.text = NSString(format: "%i", newScore)
            gameOverBestScoreLabel.zPosition = 15
            
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: highScoreName)
            var leaderboardID: String = "ZPExtLeaderBoard_Castle"
            
            if(selectedMode == "Castle"){
                leaderboardID = "ZPExtLeaderBoard_Castle"
            }else if(selectedMode == "IceAge"){
                leaderboardID = "ZPExtLeaderBoard_IceAge"
            }else if(selectedMode == "Pyramid"){
                leaderboardID = "ZPExtLeaderBoard_Pyramid"
            }else if(selectedMode == "Stadium"){
                leaderboardID = "ZPExtLeaderBoard_Stadium"
            }else if(selectedMode == "Jurassic"){
                leaderboardID = "ZPExtLeaderBoard_Jurassic"
            }
            
            if GKLocalPlayer.localPlayer().authenticated{
                var scoreReporter = GKScore(leaderboardIdentifier: leaderboardID)
                scoreReporter.value = Int64(newScore)
                var scoreArray: [GKScore] = [scoreReporter]
                GKScore.reportScores(scoreArray, {(error: NSError!) -> Void in
                    if error != nil {
                        println("error saving score")
                    }
                })
            }
        }else{
            gameOverBestScoreLabel.text = NSString(format: "%i", highScoreNumber)
            gameOverBestScoreLabel.zPosition = 15
        }
    }
    
    func shareToFacebook(){
        playButton.hidden = true
        shareButton.hidden = true
        exitButton.hidden = true
        iAdBannerView.hidden = true
        var shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        //shareToFacebook.setInitialText(NSString(format: "Amazing! I just achieved a score of %i on Zanda Panda - Extinction!", score))
        
        let screenshot = self.view?.pb_takeSnapshot()
        
        shareToFacebook.addImage(screenshot)
        self.gameViewController.presentViewController(shareToFacebook, animated: true, completion: nil)
        playButton.hidden = false
        shareButton.hidden = false
        exitButton.hidden = false
        iAdBannerView.hidden = false
    }
    
    func shareToTwitter(){
        playButton.hidden = true
        shareButton.hidden = true
        exitButton.hidden = true
        iAdBannerView.hidden = true
        var shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        //shareToTwitter.setInitialText(NSString(format: "Amazing! I just achieved a score of %i on Zanda Panda - Extinction!", score))
        
        let screenshot = self.view?.pb_takeSnapshot()
        
        shareToTwitter.addImage(screenshot)
        self.gameViewController.presentViewController(shareToTwitter, animated: true, completion: nil)
        playButton.hidden = false
        shareButton.hidden = false
        exitButton.hidden = false
        iAdBannerView.hidden = false
    }
    
    func shareToSinaWeibo(){
        playButton.hidden = true
        shareButton.hidden = true
        exitButton.hidden = true
        iAdBannerView.hidden = true
        var shareToSinaWeibo: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        shareToSinaWeibo.setInitialText(NSString(format: "Amazing! I just achieved a score of %i on Zanda Panda - Extinction!", score))
        
        let screenshot = self.view?.pb_takeSnapshot()
        
        shareToSinaWeibo.addImage(screenshot)
        self.gameViewController.presentViewController(shareToSinaWeibo, animated: true, completion: nil)
        playButton.hidden = false
        shareButton.hidden = false
        exitButton.hidden = false
        iAdBannerView.hidden = false
    }
    
    func shareToTencentWeibo(){
        playButton.hidden = true
        shareButton.hidden = true
        exitButton.hidden = true
        iAdBannerView.hidden = true
        var shareToTencentWeibo: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)
        shareToTencentWeibo.setInitialText(NSString(format: "Amazing! I just achieved a score of %i on Zanda Panda - Extinction!", score))
        
        let screenshot = self.view?.pb_takeSnapshot()
        
        shareToTencentWeibo.addImage(screenshot)
        self.gameViewController.presentViewController(shareToTencentWeibo, animated: true, completion: nil)
        playButton.hidden = false
        shareButton.hidden = false
        exitButton.hidden = false
        iAdBannerView.hidden = false
    }
}

