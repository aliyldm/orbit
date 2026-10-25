package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LevelUpCommand implements IModule
   {
      
      private static var _instance:LevelUpCommand;
      
      public var uid:int = 0;
      
      public var newLevel:int = 0;
      
      public function LevelUpCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.uid = param1;
         this.newLevel = param2;
      }
      
      public static function get instance() : LevelUpCommand
      {
         return _instance || (_instance = new LevelUpCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7513;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readInt();
         this.uid = this.uid << 9 % 32 | this.uid >>> 32 - 9 % 32;
         this.newLevel = param1.readInt();
         this.newLevel = this.newLevel << 16 % 32 | this.newLevel >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7513);
         param1.writeInt(this.uid >>> 9 % 32 | this.uid << 32 - 9 % 32);
         param1.writeInt(this.newLevel >>> 16 % 32 | this.newLevel << 32 - 16 % 32);
      }
   }
}

