package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearActivationRequest implements IModule
   {
      
      private static var _instance:PetGearActivationRequest;
      
      public var gearTypeToActivate:PetGearTypeModule;
      
      public var optParam:int = 0;
      
      public function PetGearActivationRequest(param1:PetGearTypeModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.gearTypeToActivate = new PetGearTypeModule();
         }
         else
         {
            this.gearTypeToActivate = param1;
         }
         this.optParam = param2;
      }
      
      public static function get instance() : PetGearActivationRequest
      {
         return _instance || (_instance = new PetGearActivationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 154;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.gearTypeToActivate = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gearTypeToActivate)
         {
            this.gearTypeToActivate.read(param1);
         }
         this.optParam = param1.readShort();
         this.optParam = 0xFFFF & ((0xFFFF & this.optParam) >>> 11 % 16 | (0xFFFF & this.optParam) << 16 - 11 % 16);
         this.optParam = this.optParam > 32767 ? int(this.optParam - 65536) : this.optParam;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(154);
         if(null != this.gearTypeToActivate)
         {
            this.gearTypeToActivate.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(0xFFFF & ((0xFFFF & this.optParam) << 11 % 16 | (0xFFFF & this.optParam) >>> 16 - 11 % 16));
      }
   }
}

