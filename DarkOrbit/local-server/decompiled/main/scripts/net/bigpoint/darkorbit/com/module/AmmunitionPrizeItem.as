package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionPrizeItem implements IModule
   {
      
      private static var _instance:AmmunitionPrizeItem;
      
      public static const CURRENCYTYPE_URIDIUM:int = 0;
      
      public static const CURRENCYTYPE_CREDIT:int = 1;
      
      public static const CURRENCYTYPE__MAX:int = 2;
      
      public var ammunitionType:AmmunitionTypeModule;
      
      public var currencyType:int = 0;
      
      public var amount:int = 0;
      
      public var summedPrize:int = 0;
      
      public function AmmunitionPrizeItem(param1:AmmunitionTypeModule = null, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.ammunitionType = new AmmunitionTypeModule();
         }
         else
         {
            this.ammunitionType = param1;
         }
         this.currencyType = param2;
         this.amount = param3;
         this.summedPrize = param4;
      }
      
      public static function get instance() : AmmunitionPrizeItem
      {
         return _instance || (_instance = new AmmunitionPrizeItem());
      }
      
      public function getLibcomModuleId() : int
      {
         return 39;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ammunitionType = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ammunitionType)
         {
            this.ammunitionType.read(param1);
         }
         this.currencyType = param1.readShort();
         this.amount = param1.readInt();
         this.amount = this.amount << 3 % 32 | this.amount >>> 32 - 3 % 32;
         this.summedPrize = param1.readInt();
         this.summedPrize = this.summedPrize >>> 9 % 32 | this.summedPrize << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(39);
         if(null != this.ammunitionType)
         {
            this.ammunitionType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.currencyType);
         param1.writeInt(this.amount >>> 3 % 32 | this.amount << 32 - 3 % 32);
         param1.writeInt(this.summedPrize << 9 % 32 | this.summedPrize >>> 32 - 9 % 32);
      }
   }
}

