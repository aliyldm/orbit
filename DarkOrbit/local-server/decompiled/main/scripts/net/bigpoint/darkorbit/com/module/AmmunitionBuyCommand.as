package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionBuyCommand implements IModule
   {
      
      private static var _instance:AmmunitionBuyCommand;
      
      public static const TRANSACTIONSTATUS_SUCCESSFULL:int = 0;
      
      public static const TRANSACTIONSTATUS_NOT_ENOUGH_CREDITS:int = 1;
      
      public static const TRANSACTIONSTATUS_NOT_ENOUGH_URIDIUM:int = 2;
      
      public static const TRANSACTIONSTATUS_NOT_ENOUGH_SPACE:int = 3;
      
      public static const TRANSACTIONSTATUS__MAX:int = 4;
      
      public var transactionStatus:int = 0;
      
      public var ammunitionType:AmmunitionTypeModule;
      
      public var amount:int = 0;
      
      public function AmmunitionBuyCommand(param1:int = 0, param2:AmmunitionTypeModule = null, param3:int = 0)
      {
         super();
         this.transactionStatus = param1;
         if(param2 == null)
         {
            this.ammunitionType = new AmmunitionTypeModule();
         }
         else
         {
            this.ammunitionType = param2;
         }
         this.amount = param3;
      }
      
      public static function get instance() : AmmunitionBuyCommand
      {
         return _instance || (_instance = new AmmunitionBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 42;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.transactionStatus = param1.readShort();
         this.ammunitionType = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ammunitionType)
         {
            this.ammunitionType.read(param1);
         }
         this.amount = param1.readInt();
         this.amount = this.amount >>> 1 % 32 | this.amount << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(42);
         param1.writeShort(this.transactionStatus);
         if(null != this.ammunitionType)
         {
            this.ammunitionType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.amount << 1 % 32 | this.amount >>> 32 - 1 % 32);
      }
   }
}

