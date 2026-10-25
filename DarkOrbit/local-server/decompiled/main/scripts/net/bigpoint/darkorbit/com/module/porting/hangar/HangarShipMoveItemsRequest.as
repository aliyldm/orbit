package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipMoveItemsRequest implements IModule
   {
      
      private static var _instance:HangarShipMoveItemsRequest;
      
      public var items:Vector.<Number>;
      
      public var source:String = "";
      
      public var hangarId:int = 0;
      
      public var destination:String = "";
      
      public var droneId:int = 0;
      
      public var index:int = 0;
      
      public var configId:int = 0;
      
      public var slotSet:String = "";
      
      public function HangarShipMoveItemsRequest(param1:int = 0, param2:Vector.<Number> = null, param3:String = "", param4:String = "", param5:int = 0, param6:int = 0, param7:String = "", param8:int = 0)
      {
         super();
         if(param2 == null)
         {
            this.items = new Vector.<Number>();
         }
         else
         {
            this.items = param2;
         }
         this.source = param3;
         this.hangarId = param1;
         this.destination = param4;
         this.droneId = param8;
         this.index = param5;
         this.configId = param6;
         this.slotSet = param7;
      }
      
      public static function get instance() : HangarShipMoveItemsRequest
      {
         return _instance || (_instance = new HangarShipMoveItemsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22607;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.items.push(param1.readDouble());
            _loc2_++;
         }
         this.source = param1.readUTF();
         this.hangarId = param1.readInt();
         this.hangarId = this.hangarId << 11 % 32 | this.hangarId >>> 32 - 11 % 32;
         this.destination = param1.readUTF();
         this.droneId = param1.readInt();
         this.droneId = this.droneId << 8 % 32 | this.droneId >>> 32 - 8 % 32;
         this.index = param1.readInt();
         this.index = this.index << 9 % 32 | this.index >>> 32 - 9 % 32;
         this.configId = param1.readInt();
         this.configId = this.configId << 10 % 32 | this.configId >>> 32 - 10 % 32;
         this.slotSet = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-22607);
         param1.writeByte(this.items.length);
         for each(_loc2_ in this.items)
         {
            param1.writeDouble(_loc2_);
         }
         param1.writeUTF(this.source);
         param1.writeInt(this.hangarId >>> 11 % 32 | this.hangarId << 32 - 11 % 32);
         param1.writeUTF(this.destination);
         param1.writeInt(this.droneId >>> 8 % 32 | this.droneId << 32 - 8 % 32);
         param1.writeInt(this.index >>> 9 % 32 | this.index << 32 - 9 % 32);
         param1.writeInt(this.configId >>> 10 % 32 | this.configId << 32 - 10 % 32);
         param1.writeUTF(this.slotSet);
      }
   }
}

