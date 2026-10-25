package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlBonusCommand implements IModule
   {
      
      private static var _instance:SectorControlBonusCommand;
      
      public var faction:FactionModule;
      
      public var bonusType:BoostedAttributeTypeModule;
      
      public var bonusFactor:Number = 0;
      
      public function SectorControlBonusCommand(param1:FactionModule = null, param2:BoostedAttributeTypeModule = null, param3:Number = 0)
      {
         super();
         if(param1 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param1;
         }
         if(param2 == null)
         {
            this.bonusType = new BoostedAttributeTypeModule();
         }
         else
         {
            this.bonusType = param2;
         }
         this.bonusFactor = param3;
      }
      
      public static function get instance() : SectorControlBonusCommand
      {
         return _instance || (_instance = new SectorControlBonusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6668;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.bonusType = BoostedAttributeTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.bonusType)
         {
            this.bonusType.read(param1);
         }
         this.bonusFactor = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6668);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.bonusType)
         {
            this.bonusType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeFloat(this.bonusFactor);
      }
   }
}

