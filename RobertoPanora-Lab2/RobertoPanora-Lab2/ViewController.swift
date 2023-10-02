//
//  ViewController.swift
//  RobertoPanora-Lab2
//
//  Created by Roberto Panora on 9/18/23.
//

import UIKit
import AVFoundation

class Animal {
    var timesFed: Int = 0;
    var timesPlayed: Int = 0
    var foodLevel: CGFloat = 0;
    var happiness: CGFloat = 0;
}

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var animalNoise: AVAudioPlayer!;
    
    @IBOutlet weak var imageBackground: UIView!;
    
    @IBOutlet weak var happinessBar: DisplayView!;
    
    @IBOutlet weak var foodLevelBar: DisplayView!;
    
    @IBOutlet weak var animalImage: UIImageView!;
    
    @IBOutlet weak var playLabel: UILabel!;
    
    @IBOutlet weak var fedLabel: UILabel!;
    
    var bird: Animal = Animal();
    var dog: Animal = Animal();
    var cat: Animal = Animal();
    var bunny: Animal = Animal();
    var fish: Animal = Animal();
    
    var current: String = "dog";
    

    func playHappyNoise() {
        let noise = current + "_happy";
        
        guard let path = Bundle.main.path(forResource: noise, ofType: "mp3") else {
                return }
        let url = (URL(fileURLWithPath: path))

        do {
            animalNoise = try AVAudioPlayer(contentsOf: url)
            animalNoise.prepareToPlay()
            animalNoise.play()
        } catch let error {
            print("hi")
            print(error.localizedDescription)
        }
        
    }
    
    func playMadNoise() {
        let noise = current + "_mad";
        
        
        guard let path = Bundle.main.path(forResource: noise, ofType: "mp3") else {
                return }
        let url = (URL(fileURLWithPath: path))

        do {
            animalNoise = try AVAudioPlayer(contentsOf: url)
            animalNoise?.prepareToPlay()
            animalNoise?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func playEatingNoise() {
        guard let path = Bundle.main.path(forResource: "eating", ofType: "mp3") else {
            return };
        let url = (URL(fileURLWithPath: path));

        do {
            animalNoise = try AVAudioPlayer(contentsOf: url);
            animalNoise?.prepareToPlay()
            animalNoise?.play();
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.

    }

    @IBAction func play(_ sender: Any) {
        if(foodLevelBar.value > 0) {
            playHappyNoise();
            happinessBar.value += 0.1;
            foodLevelBar.value -= 0.1;
            switch(current) {
            case "dog":
                dog.foodLevel = foodLevelBar.value;
                dog.happiness = happinessBar.value
                dog.timesPlayed += 1
                playLabel.text = "played: " + String(dog.timesPlayed);
                break;
            case "cat":
                cat.foodLevel = foodLevelBar.value;
                cat.happiness = happinessBar.value
                cat.timesPlayed += 1
                playLabel.text = "played: " + String(cat.timesPlayed);
                break;
            case "bird":
                bird.foodLevel = foodLevelBar.value;
                bird.happiness = happinessBar.value
                bird.timesPlayed += 1
                playLabel.text = "played: " + String(bird.timesPlayed);
                break;
            case "bunny":
                bunny.foodLevel = foodLevelBar.value;
                bunny.happiness = happinessBar.value
                bunny.timesPlayed += 1
                playLabel.text = "played: " + String(bunny.timesPlayed);
                break;
            case "fish":
                fish.foodLevel = foodLevelBar.value;
                fish.happiness = happinessBar.value
                fish.timesPlayed += 1
                playLabel.text = "played: " + String(fish.timesPlayed);
                break;
            default:
                print("Error!")
            }
        }
        else {
            playMadNoise();
        }
    }
    @IBAction func feed(_ sender: Any) {
        if(foodLevelBar.value < 1) {
            playEatingNoise();
            foodLevelBar.value += 0.1;
            switch(current) {
            case "dog":
                dog.foodLevel = foodLevelBar.value;
                dog.timesFed += 1
                fedLabel.text = "fed: " + String(dog.timesFed);
                break;
            case "cat":
                cat.foodLevel = foodLevelBar.value;
                cat.timesFed += 1
                fedLabel.text = "fed: " + String(cat.timesFed);
                break;
            case "bird":
                bird.foodLevel = foodLevelBar.value;
                bird.timesFed += 1
                fedLabel.text = "fed: " + String(bird.timesFed);
                break;
            case "bunny":
                bunny.foodLevel = foodLevelBar.value;
                bunny.timesFed += 1
                fedLabel.text = "fed: " + String(bunny.timesFed);
                break;
            case "fish":
                fish.foodLevel = foodLevelBar.value;
                fish.timesFed += 1
                playLabel.text = "fed: " + String(fish.timesFed);
                break;
            default:
                print("Error!")
            }
        }
    }
    
    
    @IBAction func changeToDog(_ sender: Any) {
        animalNoise.stop();
        happinessBar.value = dog.happiness;
        foodLevelBar.value = dog.foodLevel;
        playLabel.text = "played: " + String(dog.timesPlayed);
        fedLabel.text = "fed: " + String(dog.timesFed);
        animalImage.image = UIImage(named: "dog");
        current = "dog";
        imageBackground.backgroundColor = UIColor.systemMint;
    }
    @IBAction func changeToCat(_ sender: Any) {
        animalNoise?.stop();
        happinessBar.value = cat.happiness;
        foodLevelBar.value = cat.foodLevel;
        playLabel.text = "played: " + String(cat.timesPlayed);
        fedLabel.text = "fed: " + String(cat.timesFed);
        animalImage.image = UIImage(named: "cat");
        current = "cat";
        imageBackground.backgroundColor = UIColor.cyan;
    }
    @IBAction func changeToBird(_ sender: Any) {
        animalNoise?.stop();
        happinessBar.value = bird.happiness;
        foodLevelBar.value = bird.foodLevel;
        playLabel.text = "played: " + String(bird.timesPlayed);
        fedLabel.text = "fed: " + String(bird.timesFed);
        animalImage.image = UIImage(named: "bird");
        current = "bird";
        imageBackground.backgroundColor = UIColor.lightGray;
    }
    @IBAction func changeToBunny(_ sender: Any) {
        animalNoise?.stop();
        happinessBar.value = bunny.happiness;
        foodLevelBar.value = bunny.foodLevel;
        playLabel.text = "played: " + String(bunny.timesPlayed);
        fedLabel.text = "fed: " + String(bunny.timesFed);
        animalImage.image = UIImage(named: "bunny");
        current = "bunny";
        imageBackground.backgroundColor = UIColor.red;
    }
    @IBAction func changeToFish(_ sender: Any) {
        animalNoise?.stop();
        happinessBar.value = fish.happiness;
        foodLevelBar.value = fish.foodLevel;
        playLabel.text = "played: " + String(fish.timesPlayed);
        fedLabel.text = "fed: " + String(fish.timesFed);
        animalImage.image = UIImage(named: "fish");
        current = "fish";
        imageBackground.backgroundColor = UIColor.brown;
    }
    
}
