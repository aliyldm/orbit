package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearAddCommand implements IModule
   {
      
      private static var _instance:PetGearAddCommand;
      
      public var gearType:PetGearTypeModule;
      
      public var level:int = 0;
      
      public var amount:int = 0;
      
      public var enabled:Boolean = false;
      
      public function PetGearAddCommand(param1:PetGearTypeModule = null, param2:int = 0, param3:int = 0, param4:Boolean = false)
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
         this.enabled = param4;
      }
      
      public static function get instance() : PetGearAddCommand
      {
         return _instance || (_instance = new PetGearAddCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 234;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gearType = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gearType)
         {
            this.gearType.read(param1);
         }
         this.level = param1.readInt();
         this.level = this.level >>> 8 % 32 | this.level << 32 - 8 % 32;
         this.amount = param1.readInt();
         this.amount = this.amount >>> 12 % 32 | this.amount << 32 - 12 % 32;
         this.enabled = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(234);
         if(null != this.gearType)
         {
            this.gearType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.level << 8 % 32 | this.level >>> 32 - 8 % 32);
         param1.writeInt(this.amount << 12 % 32 | this.amount >>> 32 - 12 % 32);
         param1.writeBoolean(this.enabled);
      }
   }
}

