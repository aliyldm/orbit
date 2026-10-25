package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchJoinRequest implements IModule
   {
      
      private static var _instance:TeamDeathMatchJoinRequest;
      
      public var matchId:int = 0;
      
      public function TeamDeathMatchJoinRequest(param1:int = 0)
      {
         super();
         this.matchId = param1;
      }
      
      public static function get instance() : TeamDeathMatchJoinRequest
      {
         return _instance || (_instance = new TeamDeathMatchJoinRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1525;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.matchId = param1.readInt();
         this.matchId = this.matchId >>> 2 % 32 | this.matchId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1525);
         param1.writeInt(this.matchId << 2 % 32 | this.matchId >>> 32 - 2 % 32);
      }
   }
}

