package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchDraftConfirmationCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchDraftConfirmationCommand;
      
      public var seconds:int = 0;
      
      public function TeamDeathMatchDraftConfirmationCommand(param1:int = 0)
      {
         super();
         this.seconds = param1;
      }
      
      public static function get instance() : TeamDeathMatchDraftConfirmationCommand
      {
         return _instance || (_instance = new TeamDeathMatchDraftConfirmationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19521;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.seconds = param1.readInt();
         this.seconds = this.seconds << 5 % 32 | this.seconds >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19521);
         param1.writeInt(this.seconds >>> 5 % 32 | this.seconds << 32 - 5 % 32);
      }
   }
}

