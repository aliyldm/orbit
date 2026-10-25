package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PriceModule implements IModule
   {
      
      private static var _instance:PriceModule;
      
      public static const CURRENCYTYPE_CREDITS:int = 0;
      
      public static const CURRENCYTYPE_URIDIUM:int = 1;
      
      public static const CURRENCYTYPE__MAX:int = 2;
      
      public var type:int = 0;
      
      public var amount:int = 0;
      
      public function PriceModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.type = param1;
         this.amount = param2;
      }
      
      public static function get instance() : PriceModule
      {
         return _instance || (_instance = new PriceModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13131;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
         this.amount = param1.readInt();
         this.amount = this.amount << 14 % 32 | this.amount >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13131);
         param1.writeShort(this.type);
         param1.writeInt(this.amount >>> 14 % 32 | this.amount << 32 - 14 % 32);
      }
   }
}

