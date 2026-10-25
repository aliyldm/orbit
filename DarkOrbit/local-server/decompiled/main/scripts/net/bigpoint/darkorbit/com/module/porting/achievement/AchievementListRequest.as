package net.bigpoint.darkorbit.com.module.porting.achievement
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementListRequest implements IModule
   {
      
      private static var _instance:AchievementListRequest;
      
      public var displayTitleId:int = 0;
      
      public function AchievementListRequest(param1:int = 0)
      {
         super();
         this.displayTitleId = param1;
      }
      
      public static function get instance() : AchievementListRequest
      {
         return _instance || (_instance = new AchievementListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9237;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.displayTitleId = param1.readInt();
         this.displayTitleId = this.displayTitleId >>> 2 % 32 | this.displayTitleId << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9237);
         param1.writeInt(this.displayTitleId << 2 % 32 | this.displayTitleId >>> 32 - 2 % 32);
      }
   }
}

