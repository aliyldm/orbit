package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NpcEventBossInfoCommand implements IModule
   {
      
      private static var _instance:NpcEventBossInfoCommand;
      
      public var bossCount:int = 0;
      
      public var leftToKill:int = 0;
      
      public function NpcEventBossInfoCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.bossCount = param2;
         this.leftToKill = param1;
      }
      
      public static function get instance() : NpcEventBossInfoCommand
      {
         return _instance || (_instance = new NpcEventBossInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7891;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.bossCount = param1.readInt();
         this.bossCount = this.bossCount >>> 3 % 32 | this.bossCount << 32 - 3 % 32;
         this.leftToKill = param1.readInt();
         this.leftToKill = this.leftToKill >>> 4 % 32 | this.leftToKill << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7891);
         param1.writeInt(this.bossCount << 3 % 32 | this.bossCount >>> 32 - 3 % 32);
         param1.writeInt(this.leftToKill << 4 % 32 | this.leftToKill >>> 32 - 4 % 32);
      }
   }
}

