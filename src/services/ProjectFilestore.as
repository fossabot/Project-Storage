package src.services 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import net.sfxworks.firebaseREST.Core;
	import net.sfxworks.firebaseREST.events.DatabaseEvent;
	import src.definitions.FirebaseFile;
	import src.definitions.Plans;
	import src.services.events.ProjectFilestoreEvent;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class ProjectFilestore extends EventDispatcher
	{
		private var fbCore:Core
		public var fileRoutes:Object = new Object();
		private var localSave:File;
		
		private var _deviceName:String = "";
		private var _targetDevice:String = "";
		
		private var accountType:String; //Plan
		
		//P2P Service
		private var fsP2p:FilestoreP2P;
		private var fbFileNodeLocation:String =  "/files";
		
		private var bandwidthToLog:Number;
		
		private static const BANDWIDTH_LOG_URL:String = "fb./comernjer";
		
		
		public function ProjectFilestore(fbCore:Core) 
		{
			bandwidthToLog = new Number(0);
			this.fbCore = fbCore;
			
			var bandwidthTimer:Timer = new Timer(1000 * 60);
			bandwidthTimer.addEventListener(TimerEvent.TIMER, handleBandwidthTimer);
			bandwidthTimer.start();
		}
		
		private function handleBandwidthTimer(e:TimerEvent):void 
		{
			if (bandwidthToLog != 0)
				logBandwidth(bandwidthToLog);
		}
		
		public function init():void
		{
			fbCore.database.once("user/" + fbCore.auth.session.userID + "/accountType", handleAccountType, true, true);
		}
		
		
		private function handleFiles(filePaths:Object):void 
		{
			var fbFile:FirebaseFile = filePaths as FirebaseFile;
			
			for each (var fileData:Object in fbFile.files)
			{
				dispatchEvent(new ProjectFilestoreEvent(ProjectFilestoreEvent.FILE_ADDED, fileData as FirebaseFile));
			}
		}
		
		private function diveInDirectory(path:String):void
		{
			fbCore.database.once("user/" + fbCore.auth.session.userID + "/files" + path, handleFiles, true, false);
		}
		
		private function handleAccountType(accountType:Object):void 
		{
			this.accountType = accountType as String;
			switch(accountType)
			{
				case Plans.FREE:
					fsP2p = new FilestoreP2P(fbCore.auth.session.userID, _deviceName, _targetDevice);
					
					break;
				case Plans.SCALE:
					//Full up and dl functionality.
					break;
					
				case Plans.XFER:
					//Display.
					//On download complete, delete file.
					break;
			}
		}
		
		public function uploadFile(file:File, path:String):void
		{
			if (accountType == Plans.FREE)
			{
				fsP2p.transferFile(file);
			}
			else
			{
				var ba:ByteArray = new ByteArray();
				
				var fs:FileStream = new FileStream();
					fs.open(file, FileMode.READ);
					fs.readBytes(ba);
					fs.close();
				
				fbCore.storage.upload(ba, file.type, path, file.name, true);
			}
			
			//file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			//file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			
		}
		
		public function downloadFile(path:String):void
		{
			var fileDownloader:URLLoader = fbCore.storage.downloadFile(path).addEventListener(ProgressEvent.PROGRESS, handleDownloadProgress);;
			
		}
		
		private function handleDownloadProgress(e:ProgressEvent):void 
		{
			
		}
		
		public function deleteFile(path:String):void //replace with fiel refrences or something of the sort
		{
			fbCore.storage.deleteFile(path, true);
		}
		
		private function logBandwidth(num:Number):void
		{
			var urll:URLLoader = new URLLoader();
			urll.addEventListener(Event.COMPLETE, handleLogBandwithComplete);
			urll.addEventListener(IOErrorEvent.IO_ERROR, handleLogBandwidthIOError);
			var rq:URLRequest = new URLRequest(BANDWIDTH_LOG_URL + "?uid=" + fbCore.auth.session.userID + "&bandwidth=" + bandwidthToLog);
			rq.useCache = false;
			urll.load(rq);
		}
		
		private function handleLogBandwidthIOError(e:IOErrorEvent):void 
		{
			e.target.removeEventListener(Event.COMPLETE, handleLogBandwithComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleLogBandwidthIOError);
			
			trace("Could not log bandwidth.");
		}
		
		private function handleLogBandwithComplete(e:Event):void 
		{
			
			e.target.removeEventListener(Event.COMPLETE, handleLogBandwithComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, handleLogBandwidthIOError);
			
			
			var bandwidthLogged:Number = new Number(e.target.data);
			if (!isNaN(bandwidthLogged))
				bandwidthToLog -= bandwidthLogged;
			
		}
		
		private function handleRealtimePut(e:DatabaseEvent):void 
		{
			fileRoutes = JSON.parse(e.data); //need testing ffor updating sub levels
		}
		
		public function get deviceName():String 
		{
			return _deviceName;
		}
		
		public function set deviceName(value:String):void 
		{
			_deviceName = value;
		}
		
		public function get targetDevice():String 
		{
			return _targetDevice;
		}
		
		public function set targetDevice(value:String):void 
		{
			_targetDevice = value;
		}
		
	}

}