package net.bigpoint.darkorbit.com.module.porting.evoucher
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EvoucherHistoryInfoCommand implements IModule
   {
      
      private static var _instance:EvoucherHistoryInfoCommand;
      
      public var code:String = "";
      
      public var redeemDate:String = "";
      
      public var amount:int = 0;
      
      public var description:String = "";
      
      public var itemType:String = "";
      
      public function EvoucherHistoryInfoCommand(param1:String = "", param2:String = "", param3:String = "", param4:String = "", param5:int = 0)
      {
         super();
         this.code = param1;
         this.redeemDate = param3;
         this.amount = param5;
         this.description = param4;
         this.itemType = param2;
      }
      
      public static function get instance() : EvoucherHistoryInfoCommand
      {
         return _instance || (_instance = new EvoucherHistoryInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10223;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.code = param1.readUTF();
         this.redeemDate = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 1 % 32 | this.amount << 32 - 1 % 32;
         this.description = param1.readUTF();
         this.itemType = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10223);
         param1.writeUTF(this.code);
         param1.writeUTF(this.redeemDate);
         param1.writeInt(this.amount << 1 % 32 | this.amount >>> 32 - 1 % 32);
         param1.writeUTF(this.description);
         param1.writeUTF(this.itemType);
      }
   }
}

