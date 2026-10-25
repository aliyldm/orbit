package net.bigpoint.darkorbit.com.module.porting.achievement
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementInfoCommand implements IModule
   {
      
      private static var _instance:AchievementInfoCommand;
      
      public var lastUpdate:String = "";
      
      public var achievementId:String = "";
      
      public var level:int = 0;
      
      public var score:Number = 0;
      
      public function AchievementInfoCommand(param1:String = "", param2:int = 0, param3:Number = 0, param4:String = "")
      {
         super();
         this.lastUpdate = param4;
         this.achievementId = param1;
         this.level = param2;
         this.score = param3;
      }
      
      public static function get instance() : AchievementInfoCommand
      {
         return _instance || (_instance = new AchievementInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15717;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lastUpdate = param1.readUTF();
         this.achievementId = param1.readUTF();
         this.level = param1.readInt();
         this.level = this.level << 3 % 32 | this.level >>> 32 - 3 % 32;
         this.score = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15717);
         param1.writeUTF(this.lastUpdate);
         param1.writeUTF(this.achievementId);
         param1.writeInt(this.level >>> 3 % 32 | this.level << 32 - 3 % 32);
         param1.writeDouble(this.score);
      }
   }
}

