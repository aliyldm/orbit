package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameScoreUpdateCommand implements IModule
   {
      
      private static var _instance:WarGameScoreUpdateCommand;
      
      public var score:int = 0;
      
      public var teamRedScore:int = 0;
      
      public var teamBlueScore:int = 0;
      
      public function WarGameScoreUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.score = param3;
         this.teamRedScore = param1;
         this.teamBlueScore = param2;
      }
      
      public static function get instance() : WarGameScoreUpdateCommand
      {
         return _instance || (_instance = new WarGameScoreUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25477;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score = param1.readInt();
         this.score = this.score >>> 7 % 32 | this.score << 32 - 7 % 32;
         this.teamRedScore = param1.readInt();
         this.teamRedScore = this.teamRedScore << 12 % 32 | this.teamRedScore >>> 32 - 12 % 32;
         this.teamBlueScore = param1.readInt();
         this.teamBlueScore = this.teamBlueScore << 16 % 32 | this.teamBlueScore >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(25477);
         param1.writeInt(this.score << 7 % 32 | this.score >>> 32 - 7 % 32);
         param1.writeInt(this.teamRedScore >>> 12 % 32 | this.teamRedScore << 32 - 12 % 32);
         param1.writeInt(this.teamBlueScore >>> 16 % 32 | this.teamBlueScore << 32 - 16 % 32);
      }
   }
}

