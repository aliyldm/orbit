package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapEventEnemyWarningCommand implements IModule
   {
      
      private static var _instance:MapEventEnemyWarningCommand;
      
      public var enemyCount:int = 0;
      
      public function MapEventEnemyWarningCommand(param1:int = 0)
      {
         super();
         this.enemyCount = param1;
      }
      
      public static function get instance() : MapEventEnemyWarningCommand
      {
         return _instance || (_instance = new MapEventEnemyWarningCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 181;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.enemyCount = param1.readInt();
         this.enemyCount = this.enemyCount >>> 9 % 32 | this.enemyCount << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(181);
         param1.writeInt(this.enemyCount << 9 % 32 | this.enemyCount >>> 32 - 9 % 32);
      }
   }
}

