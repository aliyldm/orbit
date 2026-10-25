package net.bigpoint.darkorbit.com.module.porting.passevent
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PassItemModule implements IModule
   {
      
      private static var _instance:PassItemModule;
      
      public static const PASSITEMSTATUSTYPE_LOCK:int = 0;
      
      public static const PASSITEMSTATUSTYPE_CLAIMED:int = 1;
      
      public static const PASSITEMSTATUSTYPE_CLAIMABLE:int = 2;
      
      public static const PASSITEMSTATUSTYPE_BELOW_LEVEL:int = 3;
      
      public static const PASSITEMSTATUSTYPE__MAX:int = 4;
      
      public var level:int = 0;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public var statusType:int = 0;
      
      public function PassItemModule(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0)
      {
         super();
         this.level = param1;
         this.lootId = param2;
         this.amount = param3;
         this.statusType = param4;
      }
      
      public static function get instance() : PassItemModule
      {
         return _instance || (_instance = new PassItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19020;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level << 7 % 32 | this.level >>> 32 - 7 % 32;
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 7 % 32 | this.amount << 32 - 7 % 32;
         this.statusType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19020);
         param1.writeInt(this.level >>> 7 % 32 | this.level << 32 - 7 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount << 7 % 32 | this.amount >>> 32 - 7 % 32);
         param1.writeShort(this.statusType);
      }
   }
}

