package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VideoWindowRemoveCommand implements IModule
   {
      
      private static var _instance:VideoWindowRemoveCommand;
      
      public var windowID:int = 0;
      
      public function VideoWindowRemoveCommand(param1:int = 0)
      {
         super();
         this.windowID = param1;
      }
      
      public static function get instance() : VideoWindowRemoveCommand
      {
         return _instance || (_instance = new VideoWindowRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2272;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowID = param1.readInt();
         this.windowID = this.windowID << 6 % 32 | this.windowID >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2272);
         param1.writeInt(this.windowID >>> 6 % 32 | this.windowID << 32 - 6 % 32);
      }
   }
}

