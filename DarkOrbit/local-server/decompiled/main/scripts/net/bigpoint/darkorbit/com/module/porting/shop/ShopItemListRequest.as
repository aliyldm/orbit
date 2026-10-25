package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShopItemListRequest implements IModule
   {
      
      private static var _instance:ShopItemListRequest;
      
      public var category:String = "";
      
      public function ShopItemListRequest(param1:String = "")
      {
         super();
         this.category = param1;
      }
      
      public static function get instance() : ShopItemListRequest
      {
         return _instance || (_instance = new ShopItemListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9325;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.category = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9325);
         param1.writeUTF(this.category);
      }
   }
}

