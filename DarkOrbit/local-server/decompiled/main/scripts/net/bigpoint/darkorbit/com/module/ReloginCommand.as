package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReloginCommand implements IModule
   {
      
      private static var _instance:ReloginCommand;
      
      public var mapID:int = 0;
      
      public var delayInMillis:int = 0;
      
      public function ReloginCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.mapID = param1;
         this.delayInMillis = param2;
      }
      
      public static function get instance() : ReloginCommand
      {
         return _instance || (_instance = new ReloginCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30607;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapID = param1.readInt();
         this.mapID = this.mapID << 16 % 32 | this.mapID >>> 32 - 16 % 32;
         this.delayInMillis = param1.readInt();
         this.delayInMillis = this.delayInMillis >>> 9 % 32 | this.delayInMillis << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30607);
         param1.writeInt(this.mapID >>> 16 % 32 | this.mapID << 32 - 16 % 32);
         param1.writeInt(this.delayInMillis << 9 % 32 | this.delayInMillis >>> 32 - 9 % 32);
      }
   }
}

