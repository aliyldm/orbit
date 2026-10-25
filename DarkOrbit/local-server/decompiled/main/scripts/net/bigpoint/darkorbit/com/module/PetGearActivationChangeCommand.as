package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearActivationChangeCommand implements IModule
   {
      
      private static var _instance:PetGearActivationChangeCommand;
      
      public var gearType:PetGearTypeModule;
      
      public var active:Boolean = false;
      
      public function PetGearActivationChangeCommand(param1:PetGearTypeModule = null, param2:Boolean = false)
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
         this.active = param2;
      }
      
      public static function get instance() : PetGearActivationChangeCommand
      {
         return _instance || (_instance = new PetGearActivationChangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4943;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gearType = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gearType)
         {
            this.gearType.read(param1);
         }
         this.active = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4943);
         if(null != this.gearType)
         {
            this.gearType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.active);
      }
   }
}

