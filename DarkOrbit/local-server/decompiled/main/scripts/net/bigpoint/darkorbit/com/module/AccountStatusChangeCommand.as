package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AccountStatusChangeCommand implements IModule
   {
      
      private static var _instance:AccountStatusChangeCommand;
      
      public var premium:Boolean = false;
      
      public function AccountStatusChangeCommand(param1:Boolean = false)
      {
         super();
         this.premium = param1;
      }
      
      public static function get instance() : AccountStatusChangeCommand
      {
         return _instance || (_instance = new AccountStatusChangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16529;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.premium = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16529);
         param1.writeBoolean(this.premium);
      }
   }
}

