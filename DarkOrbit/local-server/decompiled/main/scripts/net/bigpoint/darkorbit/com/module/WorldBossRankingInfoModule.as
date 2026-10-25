package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WorldBossRankingInfoModule implements IModule
   {
      
      private static var _instance:WorldBossRankingInfoModule;
      
      public var username:String = "";
      
      public var score:int = 0;
      
      public var rank:int = 0;
      
      public var timeTaken:Number = 0;
      
      public function WorldBossRankingInfoModule(param1:int = 0, param2:String = "", param3:int = 0, param4:Number = 0)
      {
         super();
         this.username = param2;
         this.score = param3;
         this.rank = param1;
         this.timeTaken = param4;
      }
      
      public static function get instance() : WorldBossRankingInfoModule
      {
         return _instance || (_instance = new WorldBossRankingInfoModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20343;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.username = param1.readUTF();
         this.score = param1.readInt();
         this.score = this.score << 3 % 32 | this.score >>> 32 - 3 % 32;
         this.rank = param1.readInt();
         this.rank = this.rank << 4 % 32 | this.rank >>> 32 - 4 % 32;
         this.timeTaken = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20343);
         param1.writeUTF(this.username);
         param1.writeInt(this.score >>> 3 % 32 | this.score << 32 - 3 % 32);
         param1.writeInt(this.rank >>> 4 % 32 | this.rank << 32 - 4 % 32);
         param1.writeDouble(this.timeTaken);
      }
   }
}

