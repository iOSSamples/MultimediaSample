//
//  ViewController.swift
//  MultimediaSample
//
//  Created by Thales Toniolo on 10/15/14.
//  Copyright (c) 2014 FIAP. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var selectedImageView: UIImageView!
	@IBOutlet weak var musicProgress: UIProgressView!
	var player:MPMoviePlayerController?
	var musicPlayer:AVAudioPlayer?
	var updateTimer:NSTimer?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Path local do arquivo de musica
		let musicPath:NSURL = NSURL(string: NSBundle.mainBundle().pathForResource("musica", ofType: "mp3")!)!
		
		// Inicializa o player com o path
		self.musicPlayer = AVAudioPlayer(contentsOfURL: musicPath, error: nil)

		// Define o volume default inicial
		self.musicPlayer!.volume = 0.5
	}

	@IBAction func selectPictureTap(sender: AnyObject) {
		let pickerController:UIImagePickerController = UIImagePickerController()
		pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		pickerController.delegate = self
		self.presentViewController(pickerController, animated: true, completion: nil)
	}

	@IBAction func runVideoTap(sender: UIButton) {
		// Path local do arquivo de video
//		let videoPath:NSURL = NSURL(string: NSBundle.mainBundle().pathForResource("big-buck-bunny-clip", ofType: "m4v")!)!
		
		// Path remoto do arquivo de video
		let videoPath:NSURL = NSURL(string: "https://dl.dropboxusercontent.com/u/10059850/Movie.m4v")!

		// Inicializa o player com o path (local ou url)
		self.player = MPMoviePlayerController(contentURL: videoPath)
		
		// Configura o frame do video
		self.player!.view.frame = CGRectMake(20, 270, 280, 150)
		
		// Adiciona o player a view
		self.view.addSubview(self.player!.view)
		
		// Inicia o video
		self.player!.play()
	}

	func updateMusicDuration() {
		let progress:Float = Float(self.musicPlayer!.currentTime) / Float(self.musicPlayer!.duration)
		self.musicProgress.setProgress(progress, animated: true)
	}

	@IBAction func playMusicTap(sender: UIBarButtonItem) {
		if (!self.musicPlayer!.playing) {
			self.musicPlayer!.play()
			self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateMusicDuration", userInfo: nil, repeats: true)
		}
	}

	@IBAction func pauseMusicTap(sender: UIBarButtonItem) {
		if (self.musicPlayer!.playing) {
			self.musicPlayer!.pause()
			self.updateTimer!.invalidate()
		}
	}

	@IBAction func stopMusicTap(sender: UIBarButtonItem) {
		if (self.musicPlayer!.playing) {
			self.musicPlayer!.stop()
			self.updateTimer!.invalidate()
			self.musicProgress.progress = 0.0
			self.musicPlayer!.currentTime = 0.0
		}
	}

	@IBAction func setMusicVolume(sender: UISlider) {
		self.musicPlayer!.volume = sender.value
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		// Recupera a imagem selecionada
		let img:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage

		self.selectedImageView.image = img

		// Fecha a tela de selecao da imagem
		picker.dismissViewControllerAnimated(true, completion: nil)
	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		// Fecha a tela de selecao da imagem
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
}

