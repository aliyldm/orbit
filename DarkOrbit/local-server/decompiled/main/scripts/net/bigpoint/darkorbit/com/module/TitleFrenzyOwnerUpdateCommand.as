package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TitleFrenzyOwnerUpdateCommand implements IModule
   {
      
      private static var _instance:TitleFrenzyOwnerUpdateCommand;
      
      public var username:String = "";
      
      public var titleId:int = 0;
      
      public var mapId:int = 0;
      
      public function TitleFrenzyOwnerUpdateCommand(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.username = param1;
         this.titleId = param3;
         this.mapId = param2;
      }
      
      public static function get instance() : TitleFrenzyOwnerUpdateCommand
      {
         return _instance || (_instance = new TitleFrenzyOwnerUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25143;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.username = param1.readUTF();
         this.titleId = param1.readInt();
         this.titleId = this.titleId << 13 % 32 | this.titleId >>> 32 - 13 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 8 % 32 | this.mapId >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25143);
         param1.writeUTF(this.username);
         param1.writeInt(this.titleId >>> 13 % 32 | this.titleId << 32 - 13 % 32);
         param1.writeInt(this.mapId >>> 8 % 32 | this.mapId << 32 - 8 % 32);
      }
   }
}

