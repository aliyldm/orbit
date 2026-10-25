package net.bigpoint.darkorbit.com.module.porting.achievement
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementTitleCommand implements IModule
   {
      
      private static var _instance:AchievementTitleCommand;
      
      public var key:String = "";
      
      public var id:int = 0;
      
      public function AchievementTitleCommand(param1:int = 0, param2:String = "")
      {
         super();
         this.key = param2;
         this.id = param1;
      }
      
      public static function get instance() : AchievementTitleCommand
      {
         return _instance || (_instance = new AchievementTitleCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17068;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.key = param1.readUTF();
         this.id = param1.readInt();
         this.id = this.id >>> 8 % 32 | this.id << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17068);
         param1.writeUTF(this.key);
         param1.writeInt(this.id << 8 % 32 | this.id >>> 32 - 8 % 32);
      }
   }
}

