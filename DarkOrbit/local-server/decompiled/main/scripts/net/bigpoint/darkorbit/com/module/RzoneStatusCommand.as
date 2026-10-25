package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RzoneStatusCommand implements IModule
   {
      
      private static var _instance:RzoneStatusCommand;
      
      public var statusType:RzoneStatusModule;
      
      public function RzoneStatusCommand(param1:RzoneStatusModule = null)
      {
         super();
         if(param1 == null)
         {
            this.statusType = new RzoneStatusModule();
         }
         else
         {
            this.statusType = param1;
         }
      }
      
      public static function get instance() : RzoneStatusCommand
      {
         return _instance || (_instance = new RzoneStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30853;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.statusType = RzoneStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.statusType)
         {
            this.statusType.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30853);
         if(null != this.statusType)
         {
            this.statusType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

