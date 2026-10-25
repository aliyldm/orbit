package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VideoWindowNextPageCommand implements IModule
   {
      
      private static var _instance:VideoWindowNextPageCommand;
      
      public var windowID:int = 0;
      
      public function VideoWindowNextPageCommand(param1:int = 0)
      {
         super();
         this.windowID = param1;
      }
      
      public static function get instance() : VideoWindowNextPageCommand
      {
         return _instance || (_instance = new VideoWindowNextPageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2271;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.windowID = param1.readInt();
         this.windowID = this.windowID >>> 11 % 32 | this.windowID << 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2271);
         param1.writeInt(this.windowID << 11 % 32 | this.windowID >>> 32 - 11 % 32);
      }
   }
}

