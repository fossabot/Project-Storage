package src.services 
{
	import by.blooddy.crypto.MD5;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.GroupSpecifier;
	import flash.utils.ByteArray;
	import sfxworks.CommunicationLine;
	import sfxworks.Communications;
	import sfxworks.NetworkActionEvent;
	import sfxworks.NetworkEvent;
	import sfxworks.NetworkGroupEvent;
	import sfxworks.services.FileSharingService;
	import sfxworks.services.events.FileSharingEvent;
	/**
	 * ...
	 * @author Samuel Walker
	 */
	public class FilestoreP2P extends EventDispatcher
	{
		
		private var c:Communications;
		private var commLine:CommunicationLine;
		private var aBytes:ByteArray;
		
		private var assemblyFolder:File;
		private var uid:String;
		private var recieveDirectory:File;
		
		public static const FILE_BYTE_DIVIDE:Number = 10000;
		
		//Local Storage of File index
		private var md5toFileLocationMap:Object;
		private var md5toFileToRetrieveMap:Object;
		private var deviceName:String;
		private var targetDevice:String;
		
		public function FilestoreP2P(uid:String, deviceName:String, targetDevice:String) 
		{
			this.targetDevice = targetDevice;
			this.deviceName = deviceName;
			this.uid = uid;
			c = new Communications();
			
			c.addEventListener(NetworkEvent.CONNECTED, handleNetworkConnected);
			c.addEventListener(NetworkEvent.CONNECTING, handleNetworkConnecting);
			c.addEventListener(NetworkEvent.DISCONNECTED, handleNetworkDisconnected);
			c.addEventListener(NetworkGroupEvent.CONNECTION_SUCCESSFUL, handleGroupConnectionSuccessful);
			c.addEventListener(NetworkGroupEvent.POST, handleGroupPost);
			c.addEventListener(NetworkGroupEvent.OBJECT_REQUEST, handleObjectRequest);
			c.addEventListener(NetworkGroupEvent.OBJECT_RECIEVED, handleObjectRecieved);
			
			assemblyFolder = File.applicationStorageDirectory.resolvePath("assembly").createDirectory();
		}
		
		
		private function handleObjectRecieved(e:NetworkGroupEvent):void 
		{
			var saveLocation:File = assemblyFolder.resolvePath(e.groupName).createDirectory();
			saveLocation.resolvePath(e.groupObjectNumber.toString() + ".prt");
			
			var fs:FileStream = new FileStream();
				fs.open(saveLocation, FileMode.WRITE);
				fs.writeBytes(e.groupObject as ByteArray);
				fs.close();
			
			attemptAssembly(e.groupName);
			
		}
		
		private function attemptAssembly(md5:String):void 
		{
			var saveLocation:File = assemblyFolder.resolvePath(md5);
			
			for (var i:int = 0; i < md5toFileToRetrieveMap[md5].endIndex; i++)
			{
				if (saveLocation.resolvePath(i.toString() + ".prt").exists == false)
				{
					return;
				}
			}
			
			var toSend:Object = new Object();
			toSend.type = "fileCompleteNotifier";
			toSend.md5 = md5;
			
			c.postToGroup(md5, toSend);
			c.removeGroup(md5);
			
			var saveLocation:File = recieveDirectory.resolvePath(md5toFileToRetrieveMap[md5].fileName)
			
			var writeStream:FileStream = new FileStream();
			writeStream.openAsync(saveLocation, FileMode.WRITE);
			
			for (var i:int = 0; i < md5toFileToRetrieveMap[md5].endIndex; i++)
			{
				var tmp:ByteArray = new ByteArray();
				var fileLocation:File = saveLocation.resolvePath(i.toString() + ".prt");
				var readStream:FileStream = new FileStream();
					readStream.open(fileLocation, FileMode.READ)
					readStream.readBytes(tmp);
					readStream.close();
				
				fileLocation.deleteFileAsync();
				writeStream.writeBytes(tmp);
			}
			
			writeStream.close();
			
			//Dispatch complete.
			
		}
		
		//Group names are file md5s for global share abilities. Currently cotnained within user.
		//TODO: Handle Live Modification.
		private function handleObjectRequest(e:NetworkGroupEvent):void 
		{
			var fileMd5:String = e.groupName;
			
			if (md5toFileLocationMap.hasOwnProperty(e.groupName))
			{
				var targetFile:File = md5toFileLocationMap[fileMd5];
				if (targetFile.exists)
				{
					var toSend:ByteArray = new ByteArray();
					
					var fs:FileStream = new FileStream();
						fs.open(targetFile, FileMode.READ)
						var amountToRead:Number = 0;
						fs.position = e.groupObjectNumber * FILE_BYTE_DIVIDE
						if (fs.bytesAvailable > FILE_BYTE_DIVIDE)
							amountToRead = FILE_BYTE_DIVIDE;
						else
							amountToRead = fs.bytesAvailable;
						
						fs.readBytes(toSend, 0, FILE_BYTE_DIVIDE);
						fs.close();
					
					c.satisfyObjectRequest(fileMd5, e.groupObjectNumber, toSend);
				}
			}
			
		}
		
		private function handleGroupPost(e:NetworkGroupEvent):void 
		{
			if (e.groupName == "FilestoreP2P-" + uid)
			{
				var recievedObject:Object = e.groupObject;
				if (recievedObject.recievingDevice == deviceName)
				{
					if (recievedObject.type == "fileAddNotifier"); //User added file
					{
						var gs:GroupSpecifier = new GroupSpecifier(recievedObject.md5);
						gs.multicastEnabled = true;
						gs.serverChannelEnabled = true;
						gs.objectReplicationEnabled = true;
						
						md5toFileToRetrieveMap[recievedObject.md5].startIndex = recievedObject.startIndex;
						md5toFileToRetrieveMap[recievedObject.md5].endIndex = recievedObject.endIndex;
						md5toFileToRetrieveMap[recievedObject.md5].fileName = recievedObject.fileName;
						
						c.addGroup(recievedObject.md5, gs);
					}
					
				}
				else if (recievedObject.type == "fileCompleteNotifier") //User completed transfering file.
				{
					if (md5toFileLocationMap.hasOwnProperty(recievedObject.md5))
					{
						var targetFile:File = md5toFileLocationMap[recievedObject.md5];
						targetFile.deleteFileAsync(); //TODO: Flag for detete after xfer;
						c.removeGroup(recievedObject.md5);
					}
					
				}
				
			}
		}
		
		public function transferFile(file:File):void
		{
			var fs:FileStream = new FileStream();
			var tmp:ByteArray = new ByteArray();
			
			fs.open(file, FileMode.READ);
				fs.readBytes(tmp);
				fs.close();
			
			var hash:String = MD5.hashBytes(tmp);
			tmp = null; //TODO: Make this all async.
			
			md5toFileLocationMap[hash] = file;
			
			var gs:GroupSpecifier = new GroupSpecifier(hash);
				gs.multicastEnabled = true;
				gs.serverChannelEnabled = true;
				gs.objectReplicationEnabled = true;
			
			c.addGroup(hash, gs);
		}
		
		
		
		private function handleGroupConnectionSuccessful(e:NetworkGroupEvent):void 
		{
			if (md5toFileToRetrieveMap.hasOwnProperty(e.groupName))
			{
				c.addWantObject(e.groupName, md5toFileToRetrieveMap[e.groupName].startIndex, md5toFileToRetrieveMap[e.groupName].endIndex);
			}
			if (md5toFileLocationMap.hasOwnProperty(e.groupName))
			{
				var targetFile:File = md5toFileLocationMap[e.groupName] as File;
				c.addHaveObject(e.groupName, 0, Math.ceil(targetFile.size / FILE_BYTE_DIVIDE));
				
				var objectToSend:Object = new Object();
				objectToSend.md5 = e.groupName;
				objectToSend.startIndex = 0;
				objectToSend.endIndex = Math.ceil(targetFile.size / FILE_BYTE_DIVIDE);
				objectToSend.recievingDevice = targetDevice;
				objectToSend.fileName = targetFile.name;
				
				c.postToGroup(e.groupName, objectToSend);
			}
		}
		
		private function handleNetworkDisconnected(e:NetworkEvent):void 
		{
			trace("Disconnected.");
		}
		
		private function handleNetworkConnecting(e:NetworkEvent):void 
		{
			trace("Connecting.");
		}
		
		private function handleNetworkConnected(e:NetworkEvent):void 
		{
			trace("Connected.");
			
			var gs:GroupSpecifier = new GroupSpecifier("FilestoreP2P-" + uid);
			gs.multicastEnabled = true;
			gs.serverChannelEnabled = true;
			gs.objectReplicationEnabled = true;
			
			c.addGroup("FilestoreP2P-" + uid, gs);
		}
	}

}