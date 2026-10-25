package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassLevelPurchaseCommand implements IModule
   {
      
      private static var _instance:SeasonPassLevelPurchaseCommand;
      
      public var success:Boolean = false;
      
      public function SeasonPassLevelPurchaseCommand(param1:Boolean = false)
      {
         super();
         this.success = param1;
      }
      
      public static function get instance() : SeasonPassLevelPurchaseCommand
      {
         return _instance || (_instance = new SeasonPassLevelPurchaseCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15205;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15205);
         param1.writeBoolean(this.success);
      }
   }
}

