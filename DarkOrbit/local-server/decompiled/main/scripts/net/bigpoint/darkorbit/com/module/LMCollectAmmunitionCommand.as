package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMCollectAmmunitionCommand implements IModule
   {
      
      private static var _instance:LMCollectAmmunitionCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var collectedAmmunitionType:AmmunitionTypeModule;
      
      public var collectedAmount:int = 0;
      
      public function LMCollectAmmunitionCommand(param1:LogMessengerPriorityModule = null, param2:AmmunitionTypeModule = null, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         if(param2 == null)
         {
            this.collectedAmmunitionType = new AmmunitionTypeModule();
         }
         else
         {
            this.collectedAmmunitionType = param2;
         }
         this.collectedAmount = param3;
      }
      
      public static function get instance() : LMCollectAmmunitionCommand
      {
         return _instance || (_instance = new LMCollectAmmunitionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 210;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.collectedAmmunitionType = AmmunitionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.collectedAmmunitionType)
         {
            this.collectedAmmunitionType.read(param1);
         }
         this.collectedAmount = param1.readInt();
         this.collectedAmount = this.collectedAmount << 16 % 32 | this.collectedAmount >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(210);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.collectedAmmunitionType)
         {
            this.collectedAmmunitionType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.collectedAmount >>> 16 % 32 | this.collectedAmount << 32 - 16 % 32);
      }
   }
}

