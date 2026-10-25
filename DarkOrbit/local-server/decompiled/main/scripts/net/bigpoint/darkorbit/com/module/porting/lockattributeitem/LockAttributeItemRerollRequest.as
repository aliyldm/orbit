package net.bigpoint.darkorbit.com.module.porting.lockattributeitem
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LockAttributeItemRerollRequest implements IModule
   {
      
      private static var _instance:LockAttributeItemRerollRequest;
      
      public var targetItemId:Number = 0;
      
      public var lockIndexList:Vector.<int>;
      
      public function LockAttributeItemRerollRequest(param1:Number = 0, param2:Vector.<int> = null)
      {
         super();
         this.targetItemId = param1;
         if(param2 == null)
         {
            this.lockIndexList = new Vector.<int>();
         }
         else
         {
            this.lockIndexList = param2;
         }
      }
      
      public static function get instance() : LockAttributeItemRerollRequest
      {
         return _instance || (_instance = new LockAttributeItemRerollRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25491;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.targetItemId = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.lockIndexList.length > 0)
         {
            this.lockIndexList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 8 % 32 | _loc4_ >>> 32 - 8 % 32;
            this.lockIndexList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(25491);
         param1.writeDouble(this.targetItemId);
         param1.writeByte(this.lockIndexList.length);
         for each(_loc2_ in this.lockIndexList)
         {
            param1.writeInt(_loc2_ >>> 8 % 32 | _loc2_ << 32 - 8 % 32);
         }
      }
   }
}

