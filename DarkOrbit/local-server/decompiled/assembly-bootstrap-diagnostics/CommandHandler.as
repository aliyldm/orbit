package net.bigpoint.darkorbit.net.netty
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.UISystem;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.*;
   import net.bigpoint.darkorbit.utils.version.Version;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class CommandHandler
   {
      
      private static const _commandFactory:ModuleFactory = new ModuleFactory();
      
      private static const commandCache:Dictionary = new Dictionary();
      
      private static const HEADER_LENGTH:int = 3;
      
      private static const TMP:String = create();
      
      commandCache[HeroMoveCommand.instance.getLibcomModuleId()] = new HeroMoveCommand();
      commandCache[ShipInitializationCommand.instance.getLibcomModuleId()] = new ShipInitializationCommand();
      commandCache[ShipCreateCommand.instance.getLibcomModuleId()] = new ShipCreateCommand();
      commandCache[ShipSelectionCommand.instance.getLibcomModuleId()] = new ShipSelectionCommand();
      commandCache[ShipDestroyedCommand.instance.getLibcomModuleId()] = new ShipDestroyedCommand();
      commandCache[ShipDeselectionCommand.instance.getLibcomModuleId()] = new ShipDeselectionCommand();
      commandCache[MoveCommand.instance.getLibcomModuleId()] = new MoveCommand();
      commandCache[ShipRemoveCommand.instance.getLibcomModuleId()] = new ShipRemoveCommand();
      commandCache[AttackHitAssetCommand.instance.getLibcomModuleId()] = new AttackHitAssetCommand();
      commandCache[AttackHitCommand.instance.getLibcomModuleId()] = new AttackHitCommand();
      commandCache[AttackMissedCommand.instance.getLibcomModuleId()] = new AttackMissedCommand();
      commandCache[AttackLaserRunCommand.instance.getLibcomModuleId()] = new AttackLaserRunCommand();
      commandCache[AttackAbortLaserCommand.instance.getLibcomModuleId()] = new AttackAbortLaserCommand();
      commandCache[HitpointInfoCommand.instance.getLibcomModuleId()] = new HitpointInfoCommand();
      commandCache[PetLaserAttackStopCommand.instance.getLibcomModuleId()] = new PetLaserAttackStopCommand();
      commandCache[LegacyModule.instance.getLibcomModuleId()] = new LegacyModule();
      commandCache[MenuItemStatusCommand.instance.getLibcomModuleId()] = new MenuItemStatusCommand();
      
      public var executeHandler:Function;
      
      private var _socketSessionCache:SocketSessionCache = new SocketSessionCache();
      
      private var _socket:Socket;
      
      private var _compressionOffered:Boolean;
      
      private var _messageByteArray:ByteArray = new ByteArray();
      
      private var _incomingByteArray:ByteArray = new ByteArray();
      
      public function CommandHandler()
      {
         super();
      }
      
      private static function create() : String
      {
         var _loc1_:Array = [1915461,2020894066,1851878473,1853121906,1717658469,607084387,1634495561];
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeInt(_loc1_[_loc4_]);
            _loc4_++;
         }
         _loc3_.writeInt(0);
         _loc3_.position = 0;
         var _loc5_:String = _loc3_.readUTF();
         _loc3_.clear();
         return _loc5_;
      }
      
      private function retrieveMessage(param1:IDataInput) : IModule
      {
         var _loc2_:int = param1.readShort();
         var _loc3_:IModule = commandCache[_loc2_] || _commandFactory.createInstance(_loc2_);
         _loc3_.read(param1);
         return _loc3_;
      }
      
      public function readData() : void
      {
         this.parseData(this._socket);
      }
      
      public function sendMessage(param1:IModule) : void
      {
         if(param1 is LoginRequest)
         {
            this._compressionOffered = DownstreamCompression.isCompressionCapability(LoginRequest(param1).version);
         }
         this._messageByteArray.clear();
         this._messageByteArray.position = HEADER_LENGTH;
         param1.write(this._messageByteArray);
         var _loc2_:int = this._messageByteArray.length - HEADER_LENGTH;
         this._messageByteArray.position = 0;
         this._messageByteArray.writeByte((_loc2_ & 0xFF0000) >> 16);
         this._messageByteArray.writeShort(_loc2_ & 0xFFFF);
         var _loc3_:ByteArray = this._messageByteArray;
         this._socket.writeBytes(_loc3_,0,_loc3_.length);
         this._socket.flush();
      }
      
      public function setSocket(param1:Socket) : void
      {
         this._socket = param1;
         this._compressionOffered = false;
         this._socketSessionCache.reset();
      }
      
      private function parseData(param1:IDataInput) : void
      {
         var before:int = 0;
         var msgByteArray:ByteArray = null;
         var streamLength:uint = 0;
         var logicalFrames:DownstreamFrameCursor = null;
         var command:IModule = null;
         var input:IDataInput = param1;
         do
         {
            before = int(input.bytesAvailable);
            if(this._socketSessionCache.isReady())
            {
               if(before >= this._socketSessionCache.getLength())
               {
                  msgByteArray = this._incomingByteArray;
                  msgByteArray.clear();
                  this._socket.readBytes(msgByteArray,0,this._socketSessionCache.getLength());
                  try
                  {
                     logicalFrames = DownstreamCompression.decodeCursor(msgByteArray,this._compressionOffered);
                  }
                  catch(compressionError:Error)
                  {
                     _socketSessionCache.reset();
                     _socket.close();
                     _socket.dispatchEvent(new Event(Event.CLOSE));
                     return;
                  }
                  this._socketSessionCache.reset();
                  while(logicalFrames.hasMore)
                  {
                     command = this.retrieveMessage(logicalFrames.nextFrame());
                     this.dispatch(command);
                  }
               }
            }
            else if(before >= HEADER_LENGTH)
            {
               streamLength = uint(this._socket.readUnsignedByte() << 16 | this._socket.readUnsignedShort());
               if(streamLength > 0)
               {
                  this._socketSessionCache.setLength(streamLength);
               }
            }
         }
         while(before >= HEADER_LENGTH && before >= this._socketSessionCache.getLength());
      }
      
      private function dispatch(param1:IModule) : void
      {
         var command:IModule = param1;
         try
         {
            this.executeHandler(command);
         }
         catch(error:Error)
         {
            UISystem.localFlashDiag("command-error",String(command.getLibcomModuleId()) + " | " + error.name + " | " + error.message + " | " + error.getStackTrace());
            EventStreamClient.track("flash.error",{
               "message":error.message,
               "name":error.name,
               "errorID":error.errorID,
               "stackTrace":error.getStackTrace(),
               "build":Version.BUILD
            });
         }
      }
   }
}

