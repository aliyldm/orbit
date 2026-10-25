package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblySetFilterRequest implements IModule
   {
      
      private static var _instance:AssemblySetFilterRequest;
      
      public static const FILTERTYPE_ASSEMBLY:int = 0;
      
      public static const FILTERTYPE_UPGRADE:int = 1;
      
      public static const FILTERTYPE_DISASSEMBLY:int = 2;
      
      public static const FILTERTYPE__MAX:int = 3;
      
      public var assemblyWindowSettingsModule:AssemblyWindowSettingsModule;
      
      public var filterType:int = 0;
      
      public function AssemblySetFilterRequest(param1:AssemblyWindowSettingsModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.assemblyWindowSettingsModule = new AssemblyWindowSettingsModule();
         }
         else
         {
            this.assemblyWindowSettingsModule = param1;
         }
         this.filterType = param2;
      }
      
      public static function get instance() : AssemblySetFilterRequest
      {
         return _instance || (_instance = new AssemblySetFilterRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14495;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.assemblyWindowSettingsModule = AssemblyWindowSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.assemblyWindowSettingsModule)
         {
            this.assemblyWindowSettingsModule.read(param1);
         }
         this.filterType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14495);
         if(null != this.assemblyWindowSettingsModule)
         {
            this.assemblyWindowSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.filterType);
      }
   }
}

