package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RerollWindowSettingsRequest implements IModule
   {
      
      private static var _instance:RerollWindowSettingsRequest;
      
      public var rerollWindowSettingsModule:RerollWindowSettingsModule;
      
      public function RerollWindowSettingsRequest(param1:RerollWindowSettingsModule = null)
      {
         super();
         if(param1 == null)
         {
            this.rerollWindowSettingsModule = new RerollWindowSettingsModule();
         }
         else
         {
            this.rerollWindowSettingsModule = param1;
         }
      }
      
      public static function get instance() : RerollWindowSettingsRequest
      {
         return _instance || (_instance = new RerollWindowSettingsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26179;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rerollWindowSettingsModule = RerollWindowSettingsModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rerollWindowSettingsModule)
         {
            this.rerollWindowSettingsModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-26179);
         if(null != this.rerollWindowSettingsModule)
         {
            this.rerollWindowSettingsModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

