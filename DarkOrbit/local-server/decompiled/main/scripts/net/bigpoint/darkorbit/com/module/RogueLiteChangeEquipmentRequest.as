package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteChangeEquipmentRequest implements IModule
   {
      
      private static var _instance:RogueLiteChangeEquipmentRequest;
      
      public var modifiedItemIds:Vector.<Number>;
      
      public function RogueLiteChangeEquipmentRequest(param1:Vector.<Number> = null)
      {
         super();
         if(param1 == null)
         {
            this.modifiedItemIds = new Vector.<Number>();
         }
         else
         {
            this.modifiedItemIds = param1;
         }
      }
      
      public static function get instance() : RogueLiteChangeEquipmentRequest
      {
         return _instance || (_instance = new RogueLiteChangeEquipmentRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18935;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.modifiedItemIds.length > 0)
         {
            this.modifiedItemIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.modifiedItemIds.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(18935);
         param1.writeByte(this.modifiedItemIds.length);
         for each(_loc2_ in this.modifiedItemIds)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

