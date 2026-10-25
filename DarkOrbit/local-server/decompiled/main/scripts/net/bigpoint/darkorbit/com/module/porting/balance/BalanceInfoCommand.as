package net.bigpoint.darkorbit.com.module.porting.balance
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BalanceInfoCommand implements IModule
   {
      
      private static var _instance:BalanceInfoCommand;
      
      public var internalInfo:String = "";
      
      public var insertDate:String = "";
      
      public var amountType:String = "";
      
      public var amount:Number = 0;
      
      public var infoText:int = 0;
      
      public var description:String = "";
      
      public var userId:int = 0;
      
      public function BalanceInfoCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:String = "", param5:Number = 0, param6:String = "", param7:String = "")
      {
         super();
         this.internalInfo = param6;
         this.insertDate = param7;
         this.amountType = param4;
         this.amount = param5;
         this.infoText = param2;
         this.description = param3;
         this.userId = param1;
      }
      
      public static function get instance() : BalanceInfoCommand
      {
         return _instance || (_instance = new BalanceInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 32620;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.internalInfo = param1.readUTF();
         this.insertDate = param1.readUTF();
         this.amountType = param1.readUTF();
         this.amount = param1.readDouble();
         this.infoText = param1.readInt();
         this.infoText = this.infoText << 7 % 32 | this.infoText >>> 32 - 7 % 32;
         this.description = param1.readUTF();
         this.userId = param1.readInt();
         this.userId = this.userId << 16 % 32 | this.userId >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(32620);
         param1.writeUTF(this.internalInfo);
         param1.writeUTF(this.insertDate);
         param1.writeUTF(this.amountType);
         param1.writeDouble(this.amount);
         param1.writeInt(this.infoText >>> 7 % 32 | this.infoText << 32 - 7 % 32);
         param1.writeUTF(this.description);
         param1.writeInt(this.userId >>> 16 % 32 | this.userId << 32 - 16 % 32);
      }
   }
}

