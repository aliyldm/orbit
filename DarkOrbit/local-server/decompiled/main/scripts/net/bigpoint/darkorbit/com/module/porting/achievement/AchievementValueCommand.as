package net.bigpoint.darkorbit.com.module.porting.achievement
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AchievementValueCommand implements IModule
   {
      
      private static var _instance:AchievementValueCommand;
      
      public var value:Number = 0;
      
      public var key:String = "";
      
      public function AchievementValueCommand(param1:String = "", param2:Number = 0)
      {
         super();
         this.value = param2;
         this.key = param1;
      }
      
      public static function get instance() : AchievementValueCommand
      {
         return _instance || (_instance = new AchievementValueCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7724;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.value = param1.readDouble();
         this.key = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7724);
         param1.writeDouble(this.value);
         param1.writeUTF(this.key);
      }
   }
}

