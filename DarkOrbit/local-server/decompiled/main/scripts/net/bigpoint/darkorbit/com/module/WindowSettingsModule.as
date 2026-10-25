package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WindowSettingsModule implements IModule
   {
      
      private static var _instance:WindowSettingsModule;
      
      public var minmapScale:int = 0;
      
      public var barStatus:String = "";
      
      public var hideAllWindows:Boolean = false;
      
      public function WindowSettingsModule(param1:int = 0, param2:String = "", param3:Boolean = false)
      {
         super();
         this.minmapScale = param1;
         this.barStatus = param2;
         this.hideAllWindows = param3;
      }
      
      public static function get instance() : WindowSettingsModule
      {
         return _instance || (_instance = new WindowSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 272;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.minmapScale = param1.readInt();
         this.minmapScale = this.minmapScale >>> 3 % 32 | this.minmapScale << 32 - 3 % 32;
         this.barStatus = param1.readUTF();
         this.hideAllWindows = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(272);
         param1.writeInt(this.minmapScale << 3 % 32 | this.minmapScale >>> 32 - 3 % 32);
         param1.writeUTF(this.barStatus);
         param1.writeBoolean(this.hideAllWindows);
      }
   }
}

