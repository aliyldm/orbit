package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillScreenRepairRequest implements IModule
   {
      
      private static var _instance:KillScreenRepairRequest;
      
      public var selection:KillScreenOptionTypeModule;
      
      public var requestModule:LoginRequest;
      
      public function KillScreenRepairRequest(param1:KillScreenOptionTypeModule = null, param2:LoginRequest = null)
      {
         super();
         if(param1 == null)
         {
            this.selection = new KillScreenOptionTypeModule();
         }
         else
         {
            this.selection = param1;
         }
         if(param2 == null)
         {
            this.requestModule = new LoginRequest();
         }
         else
         {
            this.requestModule = param2;
         }
      }
      
      public static function get instance() : KillScreenRepairRequest
      {
         return _instance || (_instance = new KillScreenRepairRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 255;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.selection = KillScreenOptionTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.selection)
         {
            this.selection.read(param1);
         }
         this.requestModule = LoginRequest(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.requestModule)
         {
            this.requestModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(255);
         if(null != this.selection)
         {
            this.selection.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.requestModule)
         {
            this.requestModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

