package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementEarnedCommand implements IModule
   {
      
      private static var _instance:AchievementEarnedCommand;
      
      public static const BARGAINSTATE_USER_NOT_ELIGIBLE_YET:int = 0;
      
      public static const BARGAINSTATE_PENDING:int = 1;
      
      public static const BARGAINSTATE_USED:int = 2;
      
      public static const BARGAINSTATE_NO_OFFER:int = 3;
      
      public static const BARGAINSTATE__MAX:int = 4;
      
      public var state:int = 0;
      
      public var achievementId:int = 0;
      
      public var done:Boolean = false;
      
      public function AchievementEarnedCommand(param1:int = 0, param2:int = 0, param3:Boolean = false)
      {
         super();
         this.state = param1;
         this.achievementId = param2;
         this.done = param3;
      }
      
      public static function get instance() : AchievementEarnedCommand
      {
         return _instance || (_instance = new AchievementEarnedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 107;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.state = param1.readShort();
         this.achievementId = param1.readInt();
         this.achievementId = this.achievementId << 1 % 32 | this.achievementId >>> 32 - 1 % 32;
         this.done = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(107);
         param1.writeShort(this.state);
         param1.writeInt(this.achievementId >>> 1 % 32 | this.achievementId << 32 - 1 % 32);
         param1.writeBoolean(this.done);
      }
   }
}

