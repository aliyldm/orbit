package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PreBlackFridaySalesInfoCommand implements IModule
   {
      
      private static var _instance:PreBlackFridaySalesInfoCommand;
      
      public var packBought:int = 0;
      
      public function PreBlackFridaySalesInfoCommand(param1:int = 0)
      {
         super();
         this.packBought = param1;
      }
      
      public static function get instance() : PreBlackFridaySalesInfoCommand
      {
         return _instance || (_instance = new PreBlackFridaySalesInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17183;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.packBought = param1.readShort();
         this.packBought = 0xFFFF & ((0xFFFF & this.packBought) << 3 % 16 | (0xFFFF & this.packBought) >>> 16 - 3 % 16);
         this.packBought = this.packBought > 32767 ? int(this.packBought - 65536) : this.packBought;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17183);
         param1.writeShort(0xFFFF & ((0xFFFF & this.packBought) >>> 3 % 16 | (0xFFFF & this.packBought) << 16 - 3 % 16));
      }
   }
}

