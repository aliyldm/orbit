package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TechActivationRequest implements IModule
   {
      
      private static var _instance:TechActivationRequest;
      
      public var activationTechType:TechTypeModule;
      
      public function TechActivationRequest(param1:TechTypeModule = null)
      {
         super();
         if(param1 == null)
         {
            this.activationTechType = new TechTypeModule();
         }
         else
         {
            this.activationTechType = param1;
         }
      }
      
      public static function get instance() : TechActivationRequest
      {
         return _instance || (_instance = new TechActivationRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 69;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activationTechType = TechTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.activationTechType)
         {
            this.activationTechType.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(69);
         if(null != this.activationTechType)
         {
            this.activationTechType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

