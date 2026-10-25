package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipFavouriteRequest implements IModule
   {
      
      private static var _instance:HangarShipFavouriteRequest;
      
      public var favourite:int = 0;
      
      public var shipId:Number = 0;
      
      public function HangarShipFavouriteRequest(param1:int = 0, param2:Number = 0)
      {
         super();
         this.favourite = param1;
         this.shipId = param2;
      }
      
      public static function get instance() : HangarShipFavouriteRequest
      {
         return _instance || (_instance = new HangarShipFavouriteRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12147;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.favourite = param1.readByte();
         this.favourite = 0xFF & ((0xFF & this.favourite) >>> 5 % 8 | (0xFF & this.favourite) << 8 - 5 % 8);
         this.favourite = this.favourite > 127 ? int(this.favourite - 256) : this.favourite;
         this.shipId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12147);
         param1.writeByte(0xFF & ((0xFF & this.favourite) << 5 % 8 | (0xFF & this.favourite) >>> 8 - 5 % 8));
         param1.writeDouble(this.shipId);
      }
   }
}

