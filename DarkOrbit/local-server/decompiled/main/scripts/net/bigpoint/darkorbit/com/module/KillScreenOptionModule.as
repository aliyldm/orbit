package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillScreenOptionModule implements IModule
   {
      
      private static var _instance:KillScreenOptionModule;
      
      public var repairType:KillScreenOptionTypeModule;
      
      public var price:PriceModule;
      
      public var affordableForPlayer:Boolean = false;
      
      public var cooldownTime:int = 0;
      
      public var descriptionKey:MessageLocalizedWildcardCommand;
      
      public var descriptionKeyAddon:MessageLocalizedWildcardCommand;
      
      public var toolTipKey:MessageLocalizedWildcardCommand;
      
      public var buttonKey:MessageLocalizedWildcardCommand;
      
      public function KillScreenOptionModule(param1:KillScreenOptionTypeModule = null, param2:PriceModule = null, param3:Boolean = false, param4:int = 0, param5:MessageLocalizedWildcardCommand = null, param6:MessageLocalizedWildcardCommand = null, param7:MessageLocalizedWildcardCommand = null, param8:MessageLocalizedWildcardCommand = null)
      {
         super();
         if(param1 == null)
         {
            this.repairType = new KillScreenOptionTypeModule();
         }
         else
         {
            this.repairType = param1;
         }
         if(param2 == null)
         {
            this.price = new PriceModule();
         }
         else
         {
            this.price = param2;
         }
         this.affordableForPlayer = param3;
         this.cooldownTime = param4;
         if(param5 == null)
         {
            this.descriptionKey = new MessageLocalizedWildcardCommand();
         }
         else
         {
            this.descriptionKey = param5;
         }
         if(param6 == null)
         {
            this.descriptionKeyAddon = new MessageLocalizedWildcardCommand();
         }
         else
         {
            this.descriptionKeyAddon = param6;
         }
         if(param7 == null)
         {
            this.toolTipKey = new MessageLocalizedWildcardCommand();
         }
         else
         {
            this.toolTipKey = param7;
         }
         if(param8 == null)
         {
            this.buttonKey = new MessageLocalizedWildcardCommand();
         }
         else
         {
            this.buttonKey = param8;
         }
      }
      
      public static function get instance() : KillScreenOptionModule
      {
         return _instance || (_instance = new KillScreenOptionModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 253;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.repairType = KillScreenOptionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.repairType)
         {
            this.repairType.read(param1);
         }
         this.price = PriceModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.price)
         {
            this.price.read(param1);
         }
         this.affordableForPlayer = param1.readBoolean();
         this.cooldownTime = param1.readInt();
         this.cooldownTime = this.cooldownTime << 11 % 32 | this.cooldownTime >>> 32 - 11 % 32;
         this.descriptionKey = MessageLocalizedWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.descriptionKey)
         {
            this.descriptionKey.read(param1);
         }
         this.descriptionKeyAddon = MessageLocalizedWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.descriptionKeyAddon)
         {
            this.descriptionKeyAddon.read(param1);
         }
         this.toolTipKey = MessageLocalizedWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTipKey)
         {
            this.toolTipKey.read(param1);
         }
         this.buttonKey = MessageLocalizedWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.buttonKey)
         {
            this.buttonKey.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(253);
         if(null != this.repairType)
         {
            this.repairType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.price)
         {
            this.price.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.affordableForPlayer);
         param1.writeInt(this.cooldownTime >>> 11 % 32 | this.cooldownTime << 32 - 11 % 32);
         if(null != this.descriptionKey)
         {
            this.descriptionKey.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.descriptionKeyAddon)
         {
            this.descriptionKeyAddon.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.toolTipKey)
         {
            this.toolTipKey.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.buttonKey)
         {
            this.buttonKey.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

