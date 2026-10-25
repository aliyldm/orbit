package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipExtensionsCommand implements IModule
   {
      
      private static var _instance:ShipExtensionsCommand;
      
      public var userId:int = 0;
      
      public var extensionStage:int = 0;
      
      public function ShipExtensionsCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.userId = param1;
         this.extensionStage = param2;
      }
      
      public static function get instance() : ShipExtensionsCommand
      {
         return _instance || (_instance = new ShipExtensionsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 288;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId << 2 % 32 | this.userId >>> 32 - 2 % 32;
         this.extensionStage = param1.readInt();
         this.extensionStage = this.extensionStage >>> 12 % 32 | this.extensionStage << 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(288);
         param1.writeInt(this.userId >>> 2 % 32 | this.userId << 32 - 2 % 32);
         param1.writeInt(this.extensionStage << 12 % 32 | this.extensionStage >>> 32 - 12 % 32);
      }
   }
}

