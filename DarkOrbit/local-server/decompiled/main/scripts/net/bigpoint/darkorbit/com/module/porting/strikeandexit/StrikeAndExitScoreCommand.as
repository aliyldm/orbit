package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StrikeAndExitScoreCommand implements IModule
   {
      
      private static var _instance:StrikeAndExitScoreCommand;
      
      public var score:int = 0;
      
      public var uid:int = 0;
      
      public function StrikeAndExitScoreCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.score = param2;
         this.uid = param1;
      }
      
      public static function get instance() : StrikeAndExitScoreCommand
      {
         return _instance || (_instance = new StrikeAndExitScoreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24793;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score = param1.readInt();
         this.score = this.score << 2 % 32 | this.score >>> 32 - 2 % 32;
         this.uid = param1.readInt();
         this.uid = this.uid >>> 10 % 32 | this.uid << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24793);
         param1.writeInt(this.score >>> 2 % 32 | this.score << 32 - 2 % 32);
         param1.writeInt(this.uid << 10 % 32 | this.uid >>> 32 - 10 % 32);
      }
   }
}

