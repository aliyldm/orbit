package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearRemoveCommand implements IModule
   {
      
      private static var _instance:PetGearRemoveCommand;
      
      public var gearType:PetGearTypeModule;
      
      public var level:int = 0;
      
      public var amount:int = 0;
      
      public function PetGearRemoveCommand(param1:PetGearTypeModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.gearType = new PetGearTypeModule();
         }
         else
         {
            this.gearType = param1;
         }
         this.level = param2;
         this.amount = param3;
      }
      
      public static function get instance() : PetGearRemoveCommand
      {
         return _instance || (_instance = new PetGearRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 233;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gearType = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gearType)
         {
            this.gearType.read(param1);
         }
         this.level = param1.readInt();
         this.level = this.level << 11 % 32 | this.level >>> 32 - 11 % 32;
         this.amount = param1.readInt();
         this.amount = this.amount << 2 % 32 | this.amount >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(233);
         if(null != this.gearType)
         {
            this.gearType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.level >>> 11 % 32 | this.level << 32 - 11 % 32);
         param1.writeInt(this.amount >>> 2 % 32 | this.amount << 32 - 2 % 32);
      }
   }
}

