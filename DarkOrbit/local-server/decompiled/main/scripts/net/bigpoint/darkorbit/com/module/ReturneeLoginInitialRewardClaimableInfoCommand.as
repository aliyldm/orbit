package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginInitialRewardClaimableInfoCommand implements IModule
   {
      
      private static var _instance:ReturneeLoginInitialRewardClaimableInfoCommand;
      
      public var isClaimable:Boolean = false;
      
      public function ReturneeLoginInitialRewardClaimableInfoCommand(param1:Boolean = false)
      {
         super();
         this.isClaimable = param1;
      }
      
      public static function get instance() : ReturneeLoginInitialRewardClaimableInfoCommand
      {
         return _instance || (_instance = new ReturneeLoginInitialRewardClaimableInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 399;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isClaimable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(399);
         param1.writeBoolean(this.isClaimable);
      }
   }
}

