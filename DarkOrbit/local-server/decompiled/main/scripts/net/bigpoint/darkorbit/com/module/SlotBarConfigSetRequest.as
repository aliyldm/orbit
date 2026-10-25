package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SlotBarConfigSetRequest implements IModule
   {
      
      private static var _instance:SlotBarConfigSetRequest;
      
      public var slotIdTo:int = 0;
      
      public var menuItemId:String = "";
      
      public var slotBarIdFrom:String = "";
      
      public var slotIdFrom:int = 0;
      
      public var slotBarIdTo:String = "";
      
      public function SlotBarConfigSetRequest(param1:String = "", param2:int = 0, param3:String = "", param4:int = 0, param5:String = "")
      {
         super();
         this.slotIdTo = param4;
         this.menuItemId = param5;
         this.slotBarIdFrom = param1;
         this.slotIdFrom = param2;
         this.slotBarIdTo = param3;
      }
      
      public static function get instance() : SlotBarConfigSetRequest
      {
         return _instance || (_instance = new SlotBarConfigSetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32104;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.slotIdTo = param1.readInt();
         this.slotIdTo = this.slotIdTo >>> 10 % 32 | this.slotIdTo << 32 - 10 % 32;
         this.menuItemId = param1.readUTF();
         this.slotBarIdFrom = param1.readUTF();
         this.slotIdFrom = param1.readInt();
         this.slotIdFrom = this.slotIdFrom >>> 11 % 32 | this.slotIdFrom << 32 - 11 % 32;
         this.slotBarIdTo = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32104);
         param1.writeInt(this.slotIdTo << 10 % 32 | this.slotIdTo >>> 32 - 10 % 32);
         param1.writeUTF(this.menuItemId);
         param1.writeUTF(this.slotBarIdFrom);
         param1.writeInt(this.slotIdFrom << 11 % 32 | this.slotIdFrom >>> 32 - 11 % 32);
         param1.writeUTF(this.slotBarIdTo);
      }
   }
}

