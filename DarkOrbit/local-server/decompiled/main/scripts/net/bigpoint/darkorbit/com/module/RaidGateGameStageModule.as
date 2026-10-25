package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RaidGateGameStageModule extends PlayerAttributeModule
   {
      
      private static var _instance:RaidGateGameStageModule;
      
      public var isInGate:Boolean = false;
      
      public var gameStage:int = 0;
      
      public function RaidGateGameStageModule(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.isInGate = param1;
         this.gameStage = param2;
      }
      
      public static function get instance() : RaidGateGameStageModule
      {
         return _instance || (_instance = new RaidGateGameStageModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -22707;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.isInGate = param1.readBoolean();
         this.gameStage = param1.readInt();
         this.gameStage = this.gameStage >>> 8 % 32 | this.gameStage << 32 - 8 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22707);
         super.write(param1);
         param1.writeBoolean(this.isInGate);
         param1.writeInt(this.gameStage << 8 % 32 | this.gameStage >>> 32 - 8 % 32);
      }
   }
}

