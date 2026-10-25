package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationModeRequest implements IModule
   {
      
      private static var _instance:InvitationModeRequest;
      
      public var mode:InvitationModeModule;
      
      public function InvitationModeRequest(param1:InvitationModeModule = null)
      {
         super();
         if(param1 == null)
         {
            this.mode = new InvitationModeModule();
         }
         else
         {
            this.mode = param1;
         }
      }
      
      public static function get instance() : InvitationModeRequest
      {
         return _instance || (_instance = new InvitationModeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23588;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mode = InvitationModeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.mode)
         {
            this.mode.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23588);
         if(null != this.mode)
         {
            this.mode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

