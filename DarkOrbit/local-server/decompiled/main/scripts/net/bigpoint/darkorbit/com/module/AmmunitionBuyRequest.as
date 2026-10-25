package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AmmunitionBuyRequest implements IModule
   {
      
      private static var _instance:AmmunitionBuyRequest;
      
      public var ammunitionType:AmmunitionTypeModule;
      
      public var amount:int = 0;
      
      public function AmmunitionBuyRequest(param1:AmmunitionTypeModule = null, param2:int = 0)
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
         this.amount = param2;
      }
      
      public static function get instance() : AmmunitionBuyRequest
      {
         return _instance || (_instance = new AmmunitionBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 41;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ammunitionType = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ammunitionType)
         {
            this.ammunitionType.read(param1);
         }
         this.amount = param1.readInt();
         this.amount = this.amount >>> 5 % 32 | this.amount << 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(41);
         if(null != this.ammunitionType)
         {
            this.ammunitionType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.amount << 5 % 32 | this.amount >>> 32 - 5 % 32);
      }
   }
}

