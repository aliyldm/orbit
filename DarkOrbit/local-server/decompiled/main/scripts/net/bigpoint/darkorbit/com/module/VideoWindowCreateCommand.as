package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VideoWindowCreateCommand implements IModule
   {
      
      private static var _instance:VideoWindowCreateCommand;
      
      public static const VIDEOTYPES_HELPMOVIE:int = 0;
      
      public static const VIDEOTYPES_COMMANDER:int = 1;
      
      public static const VIDEOTYPES__MAX:int = 2;
      
      public var windowID:int = 0;
      
      public var windowAlign:String = "";
      
      public var showButtons:Boolean = false;
      
      public var languageKeys:Vector.<String>;
      
      public var videoID:int = 0;
      
      public var videoType:int = 0;
      
      public function VideoWindowCreateCommand(param1:int = 0, param2:String = "", param3:Boolean = false, param4:Vector.<String> = null, param5:int = 0, param6:int = 0)
      {
         super();
         this.windowID = param1;
         this.windowAlign = param2;
         this.showButtons = param3;
         if(param4 == null)
         {
            this.languageKeys = new Vector.<String>();
         }
         else
         {
            this.languageKeys = param4;
         }
         this.videoID = param5;
         this.videoType = param6;
      }
      
      public static function get instance() : VideoWindowCreateCommand
      {
         return _instance || (_instance = new VideoWindowCreateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2270;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowID = param1.readInt();
         this.windowID = this.windowID << 12 % 32 | this.windowID >>> 32 - 12 % 32;
         this.windowAlign = param1.readUTF();
         this.showButtons = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.languageKeys.length > 0)
         {
            this.languageKeys.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.languageKeys.push(param1.readUTF());
            _loc2_++;
         }
         this.videoID = param1.readInt();
         this.videoID = this.videoID << 1 % 32 | this.videoID >>> 32 - 1 % 32;
         this.videoType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(2270);
         param1.writeInt(this.windowID >>> 12 % 32 | this.windowID << 32 - 12 % 32);
         param1.writeUTF(this.windowAlign);
         param1.writeBoolean(this.showButtons);
         param1.writeByte(this.languageKeys.length);
         for each(_loc2_ in this.languageKeys)
         {
            param1.writeUTF(_loc2_);
         }
         param1.writeInt(this.videoID >>> 1 % 32 | this.videoID << 32 - 1 % 32);
         param1.writeShort(this.videoType);
      }
   }
}

