package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AgatusEventBossInfoCommand implements IModule
   {
      
      private static var _instance:AgatusEventBossInfoCommand;
      
      public var leftToKill:int = 0;
      
      public var bossCount:int = 0;
      
      public function AgatusEventBossInfoCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.leftToKill = param1;
         this.bossCount = param2;
      }
      
      public static function get instance() : AgatusEventBossInfoCommand
      {
         return _instance || (_instance = new AgatusEventBossInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31334;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.leftToKill = param1.readInt();
         this.leftToKill = this.leftToKill >>> 13 % 32 | this.leftToKill << 32 - 13 % 32;
         this.bossCount = param1.readInt();
         this.bossCount = this.bossCount << 13 % 32 | this.bossCount >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31334);
         param1.writeInt(this.leftToKill << 13 % 32 | this.leftToKill >>> 32 - 13 % 32);
         param1.writeInt(this.bossCount >>> 13 % 32 | this.bossCount << 32 - 13 % 32);
      }
   }
}

