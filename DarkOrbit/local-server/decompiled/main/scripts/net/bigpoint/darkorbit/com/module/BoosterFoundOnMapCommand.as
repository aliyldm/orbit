package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BoosterFoundOnMapCommand implements IModule
   {
      
      private static var _instance:BoosterFoundOnMapCommand;
      
      public var lootId:String = "";
      
      public var hours:int = 0;
      
      public function BoosterFoundOnMapCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.lootId = param1;
         this.hours = param2;
      }
      
      public static function get instance() : BoosterFoundOnMapCommand
      {
         return _instance || (_instance = new BoosterFoundOnMapCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 187;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.hours = param1.readInt();
         this.hours = this.hours << 10 % 32 | this.hours >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(187);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.hours >>> 10 % 32 | this.hours << 32 - 10 % 32);
      }
   }
}

